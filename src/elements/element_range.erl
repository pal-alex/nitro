-module(element_range).
-author('Vladimir Galunshchikov').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#range.show_if==false -> [<<>>];
render_element(Record) ->
    Id = case Record#range.postback of
        [] -> Record#range.id;
        Postback ->
          ID = case Record#range.id of
            [] -> nitro:temp_id();
            I -> I end,
          nitro:wire(#event{type=click, postback=Postback, target=ID,
                  source=Record#range.source, delegate=Record#range.delegate }),
          ID end,
    List = [
      %global
      {<<"accesskey">>, Record#range.accesskey},
      {<<"class">>, Record#range.class},
      {<<"contenteditable">>, case Record#range.contenteditable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"contextmenu">>, Record#range.contextmenu},
      {<<"dir">>, case Record#range.dir of "ltr" -> "ltr"; "rtl" -> "rtl"; "auto" -> "auto"; _ -> [] end},
      {<<"draggable">>, case Record#range.draggable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"dropzone">>, Record#range.dropzone},
      {<<"hidden">>, case Record#range.hidden of "hidden" -> "hidden"; _ -> [] end},
      {<<"id">>, Id},
      {<<"lang">>, Record#range.lang},
      {<<"spellcheck">>, case Record#range.spellcheck of true -> "true"; false -> "false"; _ -> [] end},
      {<<"style">>, Record#range.style},
      {<<"tabindex">>, Record#range.tabindex},
      {<<"title">>, Record#range.title},
      {<<"translate">>, case Record#range.contenteditable of "yes" -> "yes"; "no" -> "no"; _ -> [] end},      
      % spec
      {<<"autocomplete">>, case Record#range.autocomplete of true -> "on"; false -> "off"; _ -> [] end},
      {<<"autofocus">>,if Record#range.autofocus == true -> "autofocus"; true -> [] end},
      {<<"disabled">>, if Record#range.disabled == true -> "disabled"; true -> [] end},
      {<<"form">>,Record#range.form},
      {<<"list">>,Record#range.list},
      {<<"max">>,Record#range.max},
      {<<"min">>,Record#range.min},
      {<<"name">>,Record#range.name},
      {<<"step">>,Record#range.step},
      {<<"type">>, <<"range">>},
      {<<"value">>, Record#range.value} | Record#range.data_fields
    ],
    wf_tags:emit_tag(<<"input">>, nitro:render(Record#range.body), List).