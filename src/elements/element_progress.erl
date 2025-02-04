-module(element_progress).
-author('Vladimir Galunshchikov').
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#progress.show_if==false -> [<<>>];
render_element(Record) ->
    List = [
      %global
      {<<"accesskey">>, Record#progress.accesskey},
      {<<"class">>, Record#progress.class},
      {<<"contenteditable">>, case Record#progress.contenteditable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"contextmenu">>, Record#progress.contextmenu},
      {<<"dir">>, case Record#progress.dir of "ltr" -> "ltr"; "rtl" -> "rtl"; "auto" -> "auto"; _ -> [] end},
      {<<"draggable">>, case Record#progress.draggable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"dropzone">>, Record#progress.dropzone},
      {<<"hidden">>, case Record#progress.hidden of "hidden" -> "hidden"; _ -> [] end},
      {<<"id">>, Record#progress.id},
      {<<"lang">>, Record#progress.lang},
      {<<"spellcheck">>, case Record#progress.spellcheck of true -> "true"; false -> "false"; _ -> [] end},
      {<<"style">>, Record#progress.style},
      {<<"tabindex">>, Record#progress.tabindex},
      {<<"title">>, Record#progress.title},
      {<<"translate">>, case Record#progress.contenteditable of "yes" -> "yes"; "no" -> "no"; _ -> [] end},      
      % spec
      {<<"max">>,Record#progress.max},
      {<<"value">>,Record#progress.value} | Record#progress.data_fields
    ],
    wf_tags:emit_tag(<<"progress">>, nitro:render(case Record#progress.body of [] -> []; B -> B end), List).