-module(element_input_image).
-author('Vladimir Galunshchikov').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#input_image.show_if==false -> [<<>>];
render_element(Record) ->
    Id = case Record#input_image.postback of
        [] -> Record#input_image.id;
        Postback ->
          ID = case Record#input_image.id of
            [] -> nitro:temp_id();
            I -> I end,
          nitro:wire(#event{type=click, postback=Postback, target=ID,
                  source=Record#input_image.source, delegate=Record#input_image.delegate }),
          ID end,
    List = [
      %global
      {<<"accesskey">>, Record#input_image.accesskey},
      {<<"class">>, Record#input_image.class},
      {<<"contenteditable">>, case Record#input_image.contenteditable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"contextmenu">>, Record#input_image.contextmenu},
      {<<"dir">>, case Record#input_image.dir of "ltr" -> "ltr"; "rtl" -> "rtl"; "auto" -> "auto"; _ -> [] end},
      {<<"draggable">>, case Record#input_image.draggable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"dropzone">>, Record#input_image.dropzone},
      {<<"hidden">>, case Record#input_image.hidden of "hidden" -> "hidden"; _ -> [] end},
      {<<"id">>, Id},
      {<<"lang">>, Record#input_image.lang},
      {<<"spellcheck">>, case Record#input_image.spellcheck of true -> "true"; false -> "false"; _ -> [] end},
      {<<"style">>, Record#input_image.style},
      {<<"tabindex">>, Record#input_image.tabindex},
      {<<"title">>, Record#input_image.title},
      {<<"translate">>, case Record#input_image.contenteditable of "yes" -> "yes"; "no" -> "no"; _ -> [] end},      
      % spec
      {<<"alt">>,Record#input_image.alt},
      {<<"autofocus">>,if Record#input_image.autofocus == true -> "autofocus"; true -> [] end},      
      {<<"disabled">>, if Record#input_image.disabled == true -> "disabled"; true -> [] end},
      {<<"form">>,Record#input_image.form},
      {<<"formaction">>,Record#input_image.formaction},
      {<<"formenctype">>,Record#input_image.formenctype},
      {<<"formmethod">>,Record#input_image.formmethod},
      {<<"formnovalue">>,Record#input_image.formnovalue},
      {<<"formtarget">>,Record#input_image.formtarget},
      {<<"height">>,Record#input_image.height},
      {<<"name">>,Record#input_image.name},
      {<<"src">>,Record#input_image.src},
      {<<"type">>, <<"image">>},
      {<<"width">>,Record#input_image.width} | Record#input_image.data_fields
    ],
    wf_tags:emit_tag(<<"input">>, nitro:render(Record#input_image.body), List).