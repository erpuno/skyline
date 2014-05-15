-module (routes).
-author('Maxim Sokhatsky').
-behaviour (route_handler).
-include_lib("n2o/include/wf.hrl").
-export([init/2, finish/2]).

finish(State, Ctx) -> {ok, State, Ctx}.
init(State, Ctx) -> 
    Path = wf:path(Ctx#context.req),
    Module = route_prefix(Path),
    {ok, State, Ctx#context{path=Path,module=Module}}.

route_prefix(<<"/ws/",P/binary>>) -> route(P);
route_prefix(<<"/",P/binary>>) -> route(P);
route_prefix(P) -> route(P).

route(<<>>)              -> index;
route(<<"index">>)       -> index;
route(<<"login">>)       -> login;
route(<<"feed">>)        -> feed;
route(<<"account">>)     -> account;
route(<<"products">>)    -> products;
route(<<"product">>)     -> product;
route(<<"reviews">>)     -> reviews;
route(<<"chat">>)        -> chat;
route(<<"favicon.ico">>) -> static_file;
route(_)                 -> index.
