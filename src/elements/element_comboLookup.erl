-module(element_comboLookup).
% -include_lib("nitro/include/comboLookup.hrl").
-include_lib("nitro/include/nitro.hrl").
-export([render_element/1,proto/1]).

proto(#comboKeyPress{delegate=Module}=Msg) -> Module:proto(Msg);
proto(#comboSelect{delegate=Module}=Msg) -> Module:proto(Msg).

render_element(#comboLookup{id=Id, style=Style, value = Val,
  feed = Feed, disabled = Disabled, delegate = Module} = Data) ->
  nitro:render(
    #panel{id=nitro:atom([lookup, Id]), class=[dropdown],
           body=[#input{id=Id, disabled = Disabled, type="text",
                        onkeyup = nitro:jse("comboLookupKeyup('"
                               ++ nitro:to_list(Id) ++ "','"
                               ++ nitro:to_list(Feed) ++ "','"
                               ++ nitro:to_list(Module) ++ "')"),
                        onkeydown = nitro:jse("comboLookupKeydown('"
                               ++ nitro:to_list(Id) ++ "','"
                               ++ nitro:to_list(Feed) ++ "','"
                               ++ nitro:to_list(Module) ++ "')"),
                        value = Val, style = Style, class = column},
                 #panel{id=nitro:atom([comboContainer, Id]),
                        class = ['dropdown-content'],
                        onmousemove = nitro:jse("comboLookupMouseMove('"
                               ++ nitro:to_list(Id) ++ "')")
                        }]}).

