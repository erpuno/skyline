-module (routes).
-author('Maxim Sokhatsky').
-behaviour (route_handler).
-include_lib("n2o/include/wf.hrl").
-export([init/2, finish/2]).

finish(State, Ctx) -> {ok, State, Ctx}.
init(State, Ctx) -> 
    Path = wf:path(Ctx#context.req),
%    error_logger:info_msg("Routes path: ~p", [Path]),
    {Module, PathInfo} = route(Path),
    {ok, State, Ctx#context{path=PathInfo,module=Module}}.

route(<<"/">>) -> {login, []};
route(<<"/index">>) -> {index, []};
route(<<"/hello">>) -> {hello, []};
route(<<"/login">>) -> {login, []};
route(<<"/tblist">>) -> {tblist, []};
route(<<"/store2">>) -> {store2, []};
route(<<"/grid">>) -> {grid, []};
route(<<"/products">>) -> {products, []};
route(<<"/product">>) -> {product, []};
route(<<"/product", Rest/binary>>) -> {product, [Rest]};
route(<<"/feed">>) -> {feed, []};
route(<<"/chat">>) -> {chat, []};
route(<<"/ws/">>) -> {index, []};
route(<<"/ws/index">>) -> {index, []};
route(<<"/ws/login">>) -> {login, []};
route(<<"/ws/store2">>) -> {store2, []};
route(<<"/ws/hello">>) -> {hello, []};
route(<<"/ws/tblist">>) -> {tblist, []};
route(<<"/ws/grid">>) -> {grid, []};
route(<<"/ws/products">>) -> {products, []};
route(<<"/ws/product">>) -> {product, []};
route(<<"/ws/product",_Rest/binary>>) -> {product, []};
route(<<"/ws/feed">>) -> {feed, []};
route(<<"/ws/chat">>) -> {chat, []};
route(<<"/favicon.ico">>) -> {static_file, []};
route(_) -> {index, []}.

