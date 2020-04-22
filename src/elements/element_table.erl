-module(element_table).
-include_lib("nitro/include/nitro.hrl").
-compile(export_all).
-compile(nowarn_export_all).

render_element(Record) when Record#table.show_if==false -> [<<>>];
render_element(Record = #table{}) -> 
  {Header, Actions_H} = case Record#table.header of
                          [] -> {[], []};
                          H when is_tuple(H) -> {H, []};
                          _ -> {BH, AH} = nitro:render(Record#table.header),
                                RH = wf_tags:emit_tag(<<"thead">>, BH, []),
                               {RH, AH}
                        end,
  {Footer, Actions_F} = case Record#table.footer of
              [] -> {[], []};
              F when is_tuple(F) -> {F, []};
              _ -> {BF, AF} = nitro:render(Record#table.footer),
                    RF = wf_tags:emit_tag(<<"tfoot">>, BF, []),
                   {RF, AF}
            end,

  Bodies0 = case Record#table.body of
    #tbody{} = B -> B;
    [] -> #tbody{};
    unndefined -> #tbody{};
    Rows -> [case B of #tbody{}=B1 -> B1; _-> #tbody{body=B} end  || B <- Rows]
  end,
  % Caption = case Record#table.caption of
  %   [] -> "";
  %   _ -> wf_tags:emit_tag(<<"caption">>, nitro:render(Record#table.caption), [])
  % end,
  % Colgroup = case Record#table.colgroup of
  %   [] -> "";
  %   _ -> wf_tags:emit_tag(<<"colgroup">>, nitro:render(Record#table.colgroup), [])
  % end,
  Caption = [],
  Colgroup = [],
  {Bodies, Actions_B} = nitro:render(Bodies0),
  Body = [Caption, Colgroup, Header, Footer, Bodies],
  % io:format("table render: ~p~n", [Body]),
  Render = wf_tags:emit_tag( <<"table">>, Body, [
      {<<"id">>, Record#table.id},
      {<<"class">>, Record#table.class},
      {<<"style">>, Record#table.style} | Record#table.data_fields
  ]),
  Actions = Actions_H ++ Actions_F ++ Actions_B,
  {Render, Actions}
  .
