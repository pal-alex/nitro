-module(element_url).
-author('Vladimir Galunshchikov').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#url.show_if==false -> [<<>>];
render_element(Record) ->
    Id = case Record#url.postback of
        [] -> Record#url.id;
        Postback ->
          ID = case Record#url.id of
            [] -> nitro:temp_id();
            I -> I end,
          nitro:wire(#event{type=click, postback=Postback, target=ID,
                  source=Record#url.source, delegate=Record#url.delegate }),
          ID end,
    List = [
      %global
      {<<"accesskey">>, Record#url.accesskey},
      {<<"class">>, Record#url.class},
      {<<"contenteditable">>, case Record#url.contenteditable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"contextmenu">>, Record#url.contextmenu},
      {<<"dir">>, case Record#url.dir of "ltr" -> "ltr"; "rtl" -> "rtl"; "auto" -> "auto"; _ -> [] end},
      {<<"draggable">>, case Record#url.draggable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"dropzone">>, Record#url.dropzone},
      {<<"hidden">>, case Record#url.hidden of "hidden" -> "hidden"; _ -> [] end},
      {<<"id">>, Id},
      {<<"lang">>, Record#url.lang},
      {<<"spellcheck">>, case Record#url.spellcheck of true -> "true"; false -> "false"; _ -> [] end},
      {<<"style">>, Record#url.style},
      {<<"tabindex">>, Record#url.tabindex},
      {<<"title">>, Record#url.title},
      {<<"translate">>, case Record#url.contenteditable of "yes" -> "yes"; "no" -> "no"; _ -> [] end},      
      % spec
      {<<"autocomplete">>, case Record#url.autocomplete of true -> "on"; false -> "off"; _ -> [] end},
      {<<"autofocus">>,if Record#url.autofocus == true -> "autofocus"; true -> [] end},
      {<<"disabled">>, if Record#url.disabled == true -> "disabled"; true -> [] end},
      {<<"form">>,Record#url.form},
      {<<"list">>,Record#url.list},
      {<<"maxlength">>,Record#url.maxlength},
      {<<"name">>,Record#url.name},
      {<<"pattern">>,Record#url.pattern},      
      {<<"placeholder">>,Record#url.placeholder},      
      {<<"readonly">>,if Record#url.readonly == true -> "readonly"; true -> [] end},
      {<<"required">>,if Record#url.required == true -> "required"; true -> [] end},      
      {<<"size">>,Record#url.size},
      {<<"type">>, <<"url">>},
      {<<"value">>, Record#url.value} | Record#url.data_fields
    ],
    wf_tags:emit_tag(<<"input">>, nitro:render(Record#url.body), List).