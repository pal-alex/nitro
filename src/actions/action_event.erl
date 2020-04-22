-module(action_event).
-author('Maxim Sokhatsky').
-author('Andrey Martemyanov').
-include_lib("nitro/include/nitro.hrl").
-include_lib("nitro/include/event.hrl").
-compile(export_all).
-compile(nowarn_export_all).
-define(B(E), nitro:to_binary(E)).

render_action(#event{source=undefined}) -> [];
render_action(#event{postback=Postback,actions=_A,source=Source,target=Control,type=Type,delegate=D,validation=V}) ->
    E = Control,
    ValidationSource = [ S || S <- Source, not is_tuple(S) ],
    PB = wf_event:new(Postback, E, D, event, data(E, Source), ValidationSource, V),
    Command = nitro:f("{var x=qi('~s'); x && x.addEventListener('~s',
                        function (event){ event.preventDefault(); ~s});};", [E, Type, PB]),
    % io:format("action_event:render_action: ~p~n", [Command]),
    Command.
    
data(E,SourceList) ->
    Type=fun(A) when is_atom(A)   -> [ "atom('",atom_to_list(A),"')" ];
		    (A) when is_binary(A) -> [ "bin('",binary_to_list(A),"')" ];
                              (A) -> [ "string('",A,"')" ] end,
    list_to_binary(["[tuple(tuple(string('",E,"'),bin('detail')),[])",
        [ case S of {Id,Code} -> [ ",tuple(",Type(Id),",",Code,")" ];
                            _ -> [ ",tuple(",Type(S),",querySource('",?B(S),"'))" ]
          end || S <- SourceList ],"]"]).
