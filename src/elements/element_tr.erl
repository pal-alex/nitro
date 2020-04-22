-module(element_tr).
-include("nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

% render_element(Record) when Record#tr.show_if==false -> [<<>>];
render_element(Record = #tr{}) ->
  {Id, Body, Actions} = wf_render_elements:iba(Record),
  Cursor = "cursor:pointer;",
  Render  = wf_tags:emit_tag(<<"tr">>, Body, [
    {<<"id">>, Id},
    {<<"onclick">>, Record#tr.onclick},
    {<<"class">>, Record#tr.class},
    {<<"onmouseover">>, Record#tr.onmouseover},
    {<<"onmouseout">>, Record#tr.onmouseout},
    {<<"style">>, [Record#tr.style, Cursor]} | Record#tr.data_fields
  ]),
  {Render, Actions}
  .
