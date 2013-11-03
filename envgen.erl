#!/usr/bin/env escript
%% 
%% envgen: generate list of apps to run erl with
%%
%% example:
%%
%% ERL_LIBS=apps:deps erl -config sys.config -eval '[application:ensure_started(A) || A <- '$(./envgen.erl lager myapp)']'
%%
-module(envgen).
-compile([export_all]).

-define(ABORT(Str, Args), io:format(Str, Args), throw(abort)).

app_exists(App, Server) when is_atom(App) ->
    case reltool_server:get_app(Server, App) of
        {ok, _} ->
        %{ok, T} ->
            %io:format("found app: ~p: ~p~n", [App, element(5, T)]),
            true;
        _ ->
            false
    end;
app_exists(AppTuple, Server) when is_tuple(AppTuple) ->
    app_exists(element(1, AppTuple), Server).
    
validate_rel_apps(ReltoolServer, {sys, ReltoolConfig}) ->
    case lists:keyfind(rel, 1, ReltoolConfig) of
        false ->
            ok;
        {rel, _Name, _Vsn, Apps} ->
            %% Identify all the apps that do NOT exist, based on
            %% what's available from the reltool server
            Missing = lists:sort(
                        [App || App <- Apps,
                                app_exists(App, ReltoolServer) == false]),
            case Missing of
                [] ->
                    ok;
                _ ->
                    ?ABORT("Apps in {rel, ...} section not found by "
                           "reltool: ~p\n", [Missing])
            end;
        Rel ->
            %% Invalid release format!
            ?ABORT("Invalid {rel, ...} section in reltools.config: ~p\n", [Rel])
    end.

relconfig(Apps) ->
    LibDirs = [Dir || Dir <- ["apps", "deps"], case file:read_file_info(Dir) of {ok, _} -> true; _ -> false end],
    {sys, [
            {lib_dirs, LibDirs},
            {rel, "node", "1", Apps},
            {boot_rel, "node"},
            {app, observer, [{incl_cond, exclude}]}
        ]}.

main([]) ->
    ?ABORT("usage: ./envgen.erl apps", []);
main(MainApps) ->
    Relconfig = relconfig([list_to_atom(A) || A <- MainApps]),
    {ok, Server} = reltool:start_server([{config, Relconfig}]),
    validate_rel_apps(Server, Relconfig),
    {ok, {release, _Node, _Erts, Apps}} = reltool_server:get_rel(Server, "node"),
    %io:format("rel apps: ~p~n", [Apps]),
    Alist = [element(1, A) || A <- Apps],
    io:format("~w~n", [Alist]).
