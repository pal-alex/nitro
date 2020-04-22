-module(element_li).
-author('Rusty Klophaus').
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#li.show_if==false -> [<<>>];
render_element(Record) -> 
  {Body, Actions} = nitro:render(Record#li.body),
  Render = wf_tags:emit_tag(<<"li">>, Body, [
    {<<"class">>, Record#li.class},
    {<<"id">>, Record#li.id},
    {<<"style">>, Record#li.style} | Record#li.data_fields
  ]),
  {Render, Actions}.
