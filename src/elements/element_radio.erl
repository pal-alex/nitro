-module(element_radio).
-author('Rusty Klophaus').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#radio.show_if==false -> [<<>>];
render_element(Record) ->
    % ID = case Record#radio.id of
    %     [] -> nitro:temp_id();
    %     RadioID -> RadioID
    % end,

    % case Record#radio.postback of
    %     [] -> ignore;
    %     Postback -> nitro:wire(#event{type=change, postback=Postback, target=ID, delegate=Record#radio.delegate })
    % end,
    {Id, Body, Actions} = wf_render_elements:iba(Record),

    TypeChecked = case Record#radio.checked of
         true -> [{<<"checked">>, <<"">>},{<<"type">>, <<"radio">>}];
            _ -> [{<<"type">>, <<"radio">>}] end ++ case Record#radio.disabled of
         true -> [{<<"disabled">>, <<"disabled">>}];
            _ -> [] end,
    
    Render = wf_tags:emit_tag(<<"input">>, Body, TypeChecked ++ [
        {<<"id">>, Id},
        {<<"value">>, Record#radio.value},
        {<<"name">>, nitro:coalesce([Record#radio.html_name,Record#radio.name])},
        {<<"class">>, Record#radio.class},
        {<<"style">>, Record#radio.style},
        {<<"onclick">>, Record#radio.onclick},
        {<<"required">>,if Record#radio.required == true -> "required"; true -> [] end}
    ]),

    {Render, Actions}
.
