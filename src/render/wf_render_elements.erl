-module (wf_render_elements).
-author('Maxim Sokhatsky').
-include_lib ("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(E) when is_list(E) -> {E, []};
render_element(Element0) when is_tuple(Element0) ->
    Id = case element(#element.id, Element0) of
            [] -> [];
            undefined -> undefined;
            L when is_list(L) -> L;
            Other -> nitro:to_list(Other)
        end,
    Element = setelement(#element.id, Element0, Id),
    
    Actions0 = nitro:render_action(element(#element.actions, Element)),
    
    Tag = case element(#element.html_tag,Element) of [] -> nitro:to_binary(element(1, Element)); T -> T end,
    Validation = case element(#element.validation,Element) of
                    [] -> [];
                    Code -> nitro:f("{var name='~s'; qi(name).addEventListener('validation',"
                                            "function(e) { if (!(~s)) e.preventDefault(); });"
                                            "qi(name).validation = true;}",[Id, Code]) 
                 end,

    {Render, Actions1} = case element(#element.module, Element) of
                            [] -> default_render(Tag, Element);
                            undefined -> default_render(Tag, Element);
                            Module -> Module:render_element(Element) 
                        end,
    Actions = lists:flatten(Actions0 ++ Validation ++ Actions1),
    % io:format("wf_render_elements:render_element: ~p~n", [Render]),
    {nitro:to_binary(Render), Actions}
    
    ;
render_element(Element) -> io:format("Unknown Element: ~p~n\r",[Element]),
                           {[], []}.

default_render(Tag, Record) ->

    Body0 = lists:flatten([element(#element.body, Record)]),
    % io:format("wf_render_elements:default_render: ~p~n", [Body0]),

    {Body, Actions} = nitro:render(Body0),

    Render = wf_tags:emit_tag(Tag, Body,
        lists:append([
           [{<<"id">>,              element(#element.id, Record)},
            {<<"data-bind">>,       element(#element.bind, Record)},
            {<<"class">>,           element(#element.class, Record)},
            {<<"style">>,           element(#element.style, Record)},
            {<<"title">>,           element(#element.title, Record)},
            {<<"accesskey">>,       element(#element.accesskey, Record)},
            {<<"contenteditable">>, element(#element.contenteditable, Record)},
            {<<"contextmenu">>,     element(#element.contextmenu, Record)},
            {<<"dir">>,             element(#element.dir, Record)},
            {<<"draggable">>,       element(#element.draggable, Record)},
            {<<"dropzone">>,        element(#element.dropzone, Record)},
            {<<"hidden">>,          element(#element.hidden, Record)},
            {<<"lang">>,            element(#element.lang, Record)},
            {<<"spellcheck">>,      element(#element.spellcheck, Record)},
            {<<"translate">>,       element(#element.translate, Record)},
            {<<"tabindex">>,        element(#element.tabindex, Record)},
            {<<"onclick">>,         element(#element.onclick, Record)},
            {<<"onmouseout">>,      element(#element.onmouseout, Record)},
            {<<"onmouseover">>,     element(#element.onmouseover, Record)},
            {<<"onmousemove">>,     element(#element.onmousemove, Record)},
            {<<"role">>,            element(#element.role, Record)}],
        element(#element.data_fields, Record),
        element(#element.aria_states, Record)])),

    {Render, Actions}    
    .

iba(Record) -> iba(Record, click).
iba(Record, Type) ->
    ID0 = element(#element.id, Record),
    Postback = element(#element.postback, Record),
    Source = element(#element.source, Record),
    Delegate = element(#element.delegate, Record),
    Body0 = element(#element.body, Record),

    {ID, P} = case Postback of
                    [] -> {ID0, []};
                    undefined -> {ID0, []};
                    Postback ->
                            ID1 = case ID0 of [] -> nitro:temp_id(); I -> I end,
                            Event = #event{type=Type, postback=Postback, target=ID1,
                                            source=Source, delegate=Delegate},  
                            {ID1, nitro:render_action(Event)}
                end,
    {Body, Actions} = nitro:render(flatten(Body0)),
    {ID, Body, [P | Actions]}
.

flatten(Elem) when is_list(Elem) -> lists:flatten(Elem);
flatten(Elem) -> Elem.