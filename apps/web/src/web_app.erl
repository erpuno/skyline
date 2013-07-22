-module(web_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->

    application:start(sasl),
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    application:start(n2o),
    application:start(amqp_client),
    application:start(mqs),
    application:start(mnesia),
    application:start(kvs),
    application:start(asn1),
    application:start(public_key),
    application:start(inets),
    application:start(xmerl),
    application:start(oauth),
    application:start(gproc),

    web_sup:start_link().

stop(_State) ->
    ok.
