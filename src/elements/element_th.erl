-module(element_th).
-include("nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

% render_element(Record) when Record#th.show_if==false -> [<<>>];
render_element(Record) ->
  {Id, Body, Actions} = wf_render_elements:iba(Record),
  Render = wf_tags:emit_tag(<<"th">>, Body, [
    {<<"id">>, Id},
    {<<"class">>, Record#th.class},
    {<<"style">>, Record#th.style},
    {<<"rowspan">>, if Record#th.rowspan == 1 -> []; true -> Record#th.rowspan end},
    {<<"colspan">>, if Record#th.colspan == 1 -> []; true -> Record#th.colspan end},
    {<<"scope">>, Record#th.scope} | Record#th.data_fields
  ]),
  {Render, Actions}
  .
