-module(chat).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "prod", bindings=[{title,<<"Login">>},{body,body()}]} ].

message(Who,What) ->
    N=string:join(string:tokens(What,"\n")," "),
    error_logger:info_msg("~p",[N]),
  #panel{class=["media"],body=[
      #link{class=["pull-left"], body=[
          #image{class=["media-object"],image="static/img/infinity.png",width= <<"63">>} ]},
            #panel{class=["media-body"],body=[
                #h4{body=Who},
                #span{body=N} ]} ]}.

body() ->
    {ok,Pid} = wf:comet(fun() -> chat_loop() end),
    index:header() ++ [
  #panel{class=["container-fluid", chat], body=[
    #panel{class=["row-fluid"], body=[
      #h1{body= <<"N2O based WebSocket Chat">>,class=[offset3, span8]}
    ]},
    #panel{class=["row-fluid"], body=[
      #panel{class=[span3], body=[
        #h4{body= <<"Your Chats:">>},
        #list{class=[unstyled, "chat-rooms"], body=[
          #li{body=#link{body= <<"doxtop">>}},
          #li{body=#link{body= <<"maxim">>}},
          #li{body=#link{body= <<"Lobby Conference">>}} ]} ]},
      #panel{class=[span8], body=[
        #panel{id=history, class=[history], body=[
            case wf:user() of undefined -> message("System","You are not logged in. Anonymous mode!");
                              _ -> message("System","Hello, " ++ wf:user() ++ "! Here you can chat, please go on!") end ]},
        #textarea{id=message,style="display: inline-block; width: 200px; margin-top: 20px; margin-right: 20px;"},
        #button{id=send,body="Send",class=["btn","btn-primary","btn-large","btn-inverse"],postback={chat,Pid},source=[message]}
      ]}
    ]}
  ]}
  ] ++ index:footer().

event(init) ->
    Self = self(),
    wf:send(lobby,{top,5,Self}),
    Terms = wf:render(receive Top -> [ message(U,M) || {U,M} <- Top] end),
    error_logger:info_msg("Top 10: ~p",[Terms]),
    wf:insert_top(<<"history">>, Terms),
    wf:wire("$('#history').scrollTop = $('#history').scrollHeight;");
event(chat) -> wf:redirect("chat");
event(hello) -> wf:redirect("login");

event({chat,Pid}) ->
    error_logger:info_msg("Chat Pid: ~p",[Pid]),
    Username = case wf:user() of undefined -> "anonymous"; A -> A end,
    Message = wf:q(message),
    Terms = [ message("Systen","Message added"), #button{postback=hello} ],
%    wf:insert_top(<<"history">>, Terms),
    wf:wire("$('#message').focus(); $('#message').select(); "),
    wf:reg(room),
    Pid ! {message, Username, Message}.


chat_loop() ->
    receive
        {message, Username, Message} ->
            error_logger:info_msg("Comet received : ~p",[{Username,Message}]),
            Terms = message(Username,Message),
            wf:insert_top(<<"history">>, Terms),
            wf:wire("$('#history').scrollTop = $('#history').scrollHeight;"),
            wf:send(lobby,{add,{Username,Message}}),
            wf:flush(room);
        Unknown -> error_logger:info_msg("Unknown Looper Message ~p",[Unknown])
    end, chat_loop().

