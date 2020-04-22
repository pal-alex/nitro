-module(element_input).
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#input.show_if==false -> [<<>>];
render_element(Record) ->
  {Id, Body, Actions} = wf_render_elements:iba(Record),

  List = [
      %global
      {<<"accesskey">>, Record#input.accesskey},
      {<<"class">>, Record#input.class},
      {<<"contenteditable">>, case Record#input.contenteditable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"contextmenu">>, Record#input.contextmenu},
      {<<"dir">>, case Record#input.dir of "ltr" -> "ltr"; "rtl" -> "rtl"; "auto" -> "auto"; _ -> [] end},
      {<<"draggable">>, case Record#input.draggable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"dropzone">>, Record#input.dropzone},
      {<<"hidden">>, case Record#input.hidden of "hidden" -> "hidden"; _ -> [] end},
      {<<"id">>, Id},
      {<<"lang">>, Record#input.lang},
      {<<"spellcheck">>, case Record#input.spellcheck of true -> "true"; false -> "false"; _ -> [] end},
      {<<"style">>, Record#input.style},
      {<<"tabindex">>, Record#input.tabindex},
      {<<"title">>, Record#input.title},
      {<<"translate">>, case Record#input.contenteditable of "yes" -> "yes"; "no" -> "no"; _ -> [] end},
      % spec
      {<<"autofocus">>,Record#input.autofocus},
      {<<"disabled">>, if Record#input.disabled == true -> "disabled"; true -> [] end},
      {<<"name">>,Record#input.name},
      {<<"type">>, Record#input.type},
      {<<"accept">>, Record#input.accept},
      {<<"autocomplete">>, "off"},
      {<<"max">>, Record#input.max},
      {<<"checked">>, if Record#input.checked == true -> true; true -> [] end},
      {<<"aria-states">>, Record#input.aria_states},
      {<<"placeholder">>,Record#input.placeholder},
      {<<"min">>, Record#input.min},
      {<<"multiple">>, Record#input.multiple},
      {<<"pattern">>, Record#input.pattern},
      {<<"value">>, Record#input.value},
      {<<"data-bind">>, Record#input.bind},
      {<<"onkeypress">>, Record#input.onkeypress},
      {<<"onkeyup">>, Record#input.onkeyup},
      {<<"onkeydown">>, Record#input.onkeydown},
      {<<"oninput">>, Record#input.oninput},
      {<<"onfocus">>, if Record#input.onfocus==[] -> "this.select();"; true -> Record#input.onfocus end},
      {<<"onblur">>, Record#input.onblur},
      {<<"onclick">>, Record#input.onclick},
      {<<"required">>, if Record#input.required == true -> "required"; true -> [] end},
      {<<"onchange">>, Record#input.onchange} | Record#input.data_fields
    ],
    Render = wf_tags:emit_tag(<<"input">>, Body, List),
    {Render, Actions}
    .
