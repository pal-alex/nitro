-module(element_td).
-include("nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

% render_element(Record) when Record#td.show_if==false -> [<<>>];
render_element(Record) ->
  {Id, Body, Actions} = wf_render_elements:iba(Record),

  Render = wf_tags:emit_tag(<<"td">>, Body, [
            {<<"id">>, Id},
            {<<"class">>, Record#td.class},
            {<<"style">>, Record#td.style},
            {<<"onclick">>, Record#td.onclick},
            {<<"rowspan">>, if Record#td.rowspan == 1 -> []; true -> Record#td.rowspan end},
            {<<"bgcolor">>, Record#td.bgcolor},
            {<<"colspan">>, if Record#td.colspan == 1 -> []; true -> Record#td.colspan end},
            {<<"scope">>, Record#td.scope} | Record#td.data_fields
          ]),
  {Render, Actions}     
  .
