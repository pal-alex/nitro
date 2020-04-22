-module(element_image).
-author('Rusty Klophaus').
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

% render_element(Record) when Record#image.show_if==false -> {[], []};
render_element(Record) ->
  {Id, _Body, Actions} = wf_render_elements:iba(Record),
  Attributes = [
    {<<"id">>, Id},
    {<<"class">>, Record#image.class},
    {<<"title">>, Record#image.title},
    {<<"style">>, Record#image.style},
    {<<"alt">>, Record#image.alt},
    {<<"width">>, Record#image.width},
    {<<"height">>, Record#image.height},
    {<<"src">>, nitro:coalesce([Record#image.src, Record#image.image])} | Record#image.data_fields
  ],
  
  Render = wf_tags:emit_tag(<<"img">>, Attributes),
  {Render, Actions}.
