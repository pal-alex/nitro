-module(element_button).
-author('Andrew Zadorozhny').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

% render_element(Record) when Record#button.show_if==false -> [<<>>];
render_element(Record) ->
    {Id, Body, Actions} = wf_render_elements:iba(Record),

    Render = wf_tags:emit_tag(<<"button">>, Body, [
                {<<"id">>, Id},
                {<<"type">>, Record#button.type},
                {<<"name">>, Record#button.name},
                {<<"class">>, Record#button.class},
                {<<"style">>, Record#button.style},
                {<<"onchange">>, Record#button.onchange},
                {<<"onclick">>, Record#button.onclick},
                {<<"disabled">>, if Record#button.disabled == true -> "disabled"; true -> [] end},
                {<<"value">>, Record#button.value}  | Record#button.data_fields ]),
                
    {Render, Actions}.
