-module(web_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).
-compile(export_all).
-include_lib ("n2o/include/wf.hrl").
-define(APP, web).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, _} = cowboy:start_http(http, 100, [{port, 8000}],
                                           [{env, [{dispatch, dispatch_rules()}]}]),

    Pid = spawn(fun () -> wf:reg(lobby), chat_room([],0) end),

    wf:cache(mode,wf:config(n2o,mode,"prod")),

    {ok, {{one_for_one, 5, 10}, []}}.

dispatch_rules() ->
    cowboy_router:compile(
        [{'_', [
            {"/static/[...]", cowboy_static, [{directory, {priv_dir, ?APP, [<<"static">>]}},
                                                {mimetypes, {fun mimetypes:path_to_mimes/2, default}}]},
            {"/ws/[...]", bullet_handler, [{handler, n2o_bullet}]},
            {'_', n2o_cowboy, []}
    ]}]).

chat_room(List,Counter) ->
    receive
        {counter,Caller} -> Caller ! {counter,Counter}, chat_room(List,Counter);
        {inc} -> chat_room(List,Counter+1);
        {dec} -> chat_room(List,Counter-1);
        {add, Message} -> chat_room([Message|List],Counter);
        print -> io:format("~p",[List]), chat_room(List,Counter);
        {top, Number, Caller} -> Caller ! lists:sublist(List,Number), chat_room(List,Counter);
        {win, Page, Caller} -> Caller ! lists:sublist(List,Page*10,10), chat_room(List,Counter);
        _ -> chat_room(List,Counter) end.

