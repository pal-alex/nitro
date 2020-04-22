-module(wf_event).
-author('Maxim Sokhatsky').
-author('Andrey Martemyanov').
-include_lib("nitro/include/cx.hrl").
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

-record(ev,      { module, msg, trigger, name }).

-define(B(E), nitro:to_binary(E)).
-define(L(E), nitro:to_list(E)).
target({qs,S}) -> ["qs('",nitro:js_escape(?L(S)), "')"];
target(Id)     -> ["qi('",nitro:js_escape(?L(Id)),"')"].

new(P,E,D,N,Data,Source) -> new(P, E, D, N, Data, Source, []).

new(bin,Data) -> "ws.send(enc(tuple(atom('bin'),bin('",(nitro:pickle(Data))/binary,"'))));".
new([], _, _, _, _, _, _) -> [];
new(undefined, _, _, _, _, _, _) -> [];
new(Postback, Element, Delegate, Name, Data, Source, Validation) ->
    Module = nitro:coalesce([Delegate, ?CTX#cx.module]),
    Join=fun([]) -> [];
           ([E]) -> [$'|E]++[$'];
         ([H|T]) -> [[$'|H]++[$']] ++ [ [$,,$'|E]++[$'] || E <- T ] end,
    Event = #ev{name=Name, module=Module, msg=Postback, trigger=Element}, 
    ValidateSources = Join([ nitro:to_list(S) || S <- Source, S =/= [] andalso is_tuple(S) == false ]),
    ["{ if (validateSources([", ValidateSources, "])) 
      { ",?B(Validation)," m = enc(tuple(atom('",?B(application:get_env(n2o,event,pickle)),"'),
                                        bin('", Element, "'),
                                        bin('", nitro:pickle(Event), "'),
                                        ", Data, "));
                           ws.send(m); } 
                      else console.log('Validation Error'); }"].


  % new(Postback, Element, Delegate, Name, Data, Source, Validation) ->
  %     Module = nitro:coalesce([Delegate, ?CTX#cx.module]),
  %     Join=fun([]) -> [];
  %             ([E]) -> [$'|E]++[$'];
  %           ([H|T]) -> [[$'|H]++[$']] ++ [ [$,,$'|E]++[$'] || E <- T ] end,
  %     Event = #ev{name=Name, module=Module, msg=Postback, trigger=Element}, 
  %     ValidateSources = Join([ nitro:to_list(S) || S <- Source, S =/= [] andalso is_tuple(S) == false ]),
  %     list_to_binary(["{ if (validateSources([", ValidateSources, "])) 
  %       { ",?B(Validation)," m = enc(tuple(atom('",?B(application:get_env(n2o,event,pickle)),"'),
  %                                         bin('", Element, "'),
  %                                         bin('", nitro:pickle(Event), "'), 
  %                                         ", Data, "));
  %                             ws.send(m); } 
  %                       else console.log('Validation Error'); }"]).