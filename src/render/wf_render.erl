-module(wf_render).
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_item([]) -> {[], []};
render_item(undefined) -> {[], []};
render_item(E) when element(2,E) =:= element -> 
    R = wf_render_elements:render_element(E),
    % io:format("element: ~p~n", [R]),
    R
    ;
render_item(E) when element(2,E) =:= action  -> {[], render_action(E)};
%     % io:format("action: ~p~n", [E]),
%     R = wf_render_actions:render_action(E),
%     % io:format("action: ~p~n", [R]),
%     R
%     ;
% render_item(E) when is_tuple(E) -> E;
render_item(E) -> {E, []}
.


render([]) -> {[], []};
render(undefined) -> {[], []};
render(<<E/binary>>) -> {E, []};
render(E) when is_bitstring(E) -> {E, []};
render(Elements) when is_list(Elements) ->

    HasRecords = lists:any(fun(E) -> is_tuple(E) andalso (element(2, E) == action 
                                                          orelse element(2, E) == element
                                                          )
                           end, Elements),

    case HasRecords == [] of
        true -> {Elements, []};
        false -> {Render0, Actions0} = lists:foldl(fun(E, {R0, A0}) -> 
                                                                {R, A} = render_item(E),
                                                                {[R | R0], [A | A0]}
                                                            end, {[], []}, Elements),
                        % Render = lists:reverse(lists:flatten([Render0 | Other])),
                        Render = lists:reverse(lists:flatten([Render0])),
                        Actions = [nitro:to_binary(lists:flatten([Actions0]))],
                      
                        Result = {Render, Actions},
                        % io:format("rendered elements: ~p~n", [Result]),
                        Result
    end

    % {Handle, Other} = lists:partition(fun(E) -> is_tuple(E) andalso (element(2, E) == action 
    %                                                                 % orelse element(2, E) == element
    %                                                                 )
    %                                   end, Elements),

    % case Handle == [] of
    %     true -> {Other, []};
    %     false -> 
    %             {Render0, Actions0} = lists:foldl(fun(E, {R0, A0}) -> 
    %                                                     {R, A} = render_item(E),
    %                                                     {[R | R0], [A | A0]}
    %                                                 end, {[], []}, Handle),
    %             % Render = lists:reverse(lists:flatten([Render0 | Other])),
    %             Render = lists:reverse(lists:flatten([Render0])),
    %             Actions = [nitro:to_binary(lists:flatten([Actions0]))],
              
    %             Result = {Render, Actions},
    %             % io:format("rendered elements: ~p~n", [Result]),
    %             Result
    % end

    % io:format("elements: ~p~n", [Other]),
    % io:format("actions: ~p~n", [Actions]),
    % [ render_item(E) || E <- Other ] ++ [ render_item(E) || E <- Actions ]
    ;
render(Elements) -> render_item(Elements).

render_action([]) -> [];
render_action(undefined) -> [];
render_action(Elements) when is_list(Elements) -> 
    {Handle, Other} = lists:partition(fun(E) -> is_tuple(E) andalso element(2, E) == action 
                                      end, Elements),
    case Handle == [] of
        true -> Other;
        false -> [ render_action(E) || E <- Handle ] ++ Other
    end;
render_action(Element) when is_tuple(Element) andalso element(2, Element) == action -> wf_render_actions:render_action(Element);
render_action(Element) -> Element
.

