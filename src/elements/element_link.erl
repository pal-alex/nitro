-module(element_link).
-author('Rusty Klophaus').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#link.show_if==false -> [<<>>];
render_element(Record) -> 
  {Id, Body, Actions} = wf_render_elements:iba(Record),

    List = [
      % global
      {<<"id">>, Id},
      {<<"accesskey">>, Record#link.accesskey},
      {<<"class">>, Record#link.class},
      {<<"contenteditable">>, case Record#link.contenteditable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"contextmenu">>, Record#link.contextmenu},
      {<<"dir">>, case Record#link.dir of "ltr" -> "ltr"; "rtl" -> "rtl"; "auto" -> "auto"; _ -> [] end},
      {<<"draggable">>, case Record#link.draggable of true -> "true"; false -> "false"; _ -> [] end},
      {<<"dropzone">>, Record#link.dropzone},
      {<<"hidden">>, case Record#link.hidden of "hidden" -> "hidden"; _ -> [] end},
      {<<"lang">>, Record#link.lang},
      {<<"spellcheck">>, case Record#link.spellcheck of true -> "true"; false -> "false"; _ -> [] end},
      {<<"style">>, Record#link.style},
      {<<"tabindex">>, Record#link.tabindex},
      {<<"title">>, Record#link.title},
      {<<"translate">>, case Record#link.contenteditable of "yes" -> "yes"; "no" -> "no"; _ -> [] end},      
      % spec
      {<<"href">>, nitro:coalesce([Record#link.href,Record#link.url])},
      {<<"hreflang">>, Record#link.hreflang},
      {<<"target">>, Record#link.target},
      {<<"media">>, Record#link.media},
      {<<"rel">>, Record#link.rel},
      {<<"type">>, Record#link.type},
      {<<"download">>, Record#link.download},
      {<<"name">>, Record#link.name},
      {<<"onclick">>, Record#link.onclick},
      {<<"onmouseover">>, Record#link.onmouseover} | Record#link.data_fields ],
  Render = wf_tags:emit_tag(<<"a">>, Body, List),
  {Render, Actions}
  .
