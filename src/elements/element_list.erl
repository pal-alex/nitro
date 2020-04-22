-module(element_list).
-author('Rusty Klophaus').
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#list.show_if==false -> [<<>>];
render_element(Record = #list{}) -> 
  Tag = case Record#list.numbered of true -> <<"ol">>; _ -> <<"ul">> end,

  {Body, Actions} = nitro:render(Record#list.body),
  Render = wf_tags:emit_tag(Tag, Body, [
    {<<"id">>, Record#list.id},
    {<<"class">>, Record#list.class},
    {<<"style">>, Record#list.style} | Record#list.data_fields
  ]),
  {Render, Actions}.

