-module(web_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).
-compile(export_all).
-include_lib ("n2o/include/wf.hrl").
-include("users.hrl").
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

    users:init(),

    Pid = spawn(fun () -> wf:reg(lobby), chat_room([]) end),

    {ok, {{one_for_one, 5, 10}, []}}.

dispatch_rules() ->
    cowboy_router:compile(
        [{'_', [
            {"/static/[...]", cowboy_static, [{directory, {priv_dir, ?APP, [<<"static">>]}},
                                                {mimetypes, {fun mimetypes:path_to_mimes/2, default}}]},
            {"/rest/:bucket", n2o_rest, []},
            {"/rest/:bucket/:key", n2o_rest, []},
            {"/rest/:bucket/:key/[...]", n2o_rest, []},
            {"/ws/[...]", bullet_handler, [{handler, n2o_bullet}]},
            {'_', n2o_cowboy, []}
    ]}]).

chat_room(List) ->
    receive
         {add, Message} -> chat_room([Message|List]);
         print -> io:format("~p",[List]), chat_room(List);
         {top, Number, Caller} -> Caller ! lists:sublist(List,Number), chat_room(List);
         {win, Page, Caller} -> Caller ! lists:sublist(List,Page*10,10), chat_room(List);
         _ -> chat_room(List)
    end.

