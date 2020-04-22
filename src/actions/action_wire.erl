-module(action_wire).
-author('Maxim Sokhatsky').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_action(#wire{actions=Actions}) -> nitro:render_action(Actions);
render_action(S) when is_list(S) -> S;
render_action(_) -> [].

wire(A) -> 
        %    Actions = case get(actions) of undefined -> []; E -> E end,
        %    Data = #wire{actions=A},
        %    put(actions, Actions++[Data]), 
        %    nitro:put(actions, Data, false),
             nitro:actions(A),
           [].
