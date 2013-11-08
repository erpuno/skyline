-module(chat).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").

main() -> 
  [ #dtl{file = wf:cache(mode), ext="dtl", bindings=[{title,<<"Login">>},{body,body()}]} ].

items() ->
    Link1 = {[{name, "Amazon"}, {url, "http://amazon.com"}]},
    Link2 = {[{name, "Google"}, {url, "http://google.com"}]},
    Link3 = {[{name, "Microsoft"}, {url, "http://microsoft.com"}]},
    RenderVars = {items, [Link1, Link2, Link3]}.

message(Who,What) ->
    error_logger:info_msg("~p",[What]),
  #panel{class=["media"],body=[
      #link{class=["pull-left"], body=[
          #image{class=["media-object"],image="static/img/infinity.png",width= <<"63">>} ]},
            #panel{class=["media-body"],body=[
                #h4{body= unicode:characters_to_binary(Who)},
                #span{body=wf:js_escape(What)} ]} ]}.

body() ->
%    wf:wire(#wire{actions=#jq{target="ok",method=[method],trigger="self",type="type"}}),
    {ok,Pid} = wf:comet(fun() -> chat_loop() end),
    {ok,Pid2} = wf:async("looper",fun() -> loop(0) end),
    error_logger:info_msg("comet: ~p", [Pid2]),
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
                              User -> message("System", "Hello, "++ 
        case User#user.display_name of <<N/binary>> -> binary_to_list(N); 
             undefined -> "Anonymous";
              L -> L end
     ++ "! Here you can chat, please go on!") end ]},
        #textarea{id=message,style="display: inline-block; width: 200px; margin-top: 20px; margin-right: 20px;"},
        #button{id=send,body="Send",class=["btn","btn-primary","btn-large","btn-inverse"],postback={chat,Pid},source=[message]}
      ]}
    ]}
  ]},

    #span   { id=counter,body="0" },
    #button { id=increment, body="Send", postback={inc,Pid2} }

  ] ++ index:footer().


event({inc,Pid}) -> wf:info("Inc"), Pid ! inc;

event(init) ->
    Self = self(),
    wf:reg(room),
    wf:reg(room2),
    wf:send(lobby,{top,5,Self}),
    Terms = wf:render(receive Top -> [ message(U,M) || {U,M} <- Top] end),
    error_logger:info_msg("Top 10: ~p",[Terms]),
    wf:insert_top(<<"history">>, Terms),
    wf:wire("$('#history').scrollTop = $('#history').scrollHeight;");
event(chat) -> wf:redirect("chat");
event({counter,C}) -> wf:update(onlinenumber,wf:to_list(C));
event(hello) -> wf:redirect("login");
event(<<"PING">>) -> ok;

event({chat,Pid}) ->
    wf:wire(#jq{target=n2ostatus,method=[show,select],args=[]}),
    error_logger:info_msg("Chat Pid: ~p",[Pid]),
    Username = case wf:user() of undefined -> "anonymous"; A -> A#user.display_name end,
    Message = wf:q(message),
    Terms = [ message("Systen","Message added"), #button{postback=hello} ],
%    wf:update(history, [#span{body="hello"},#br{}]),
    wf:wire("$('#message').focus(); $('#message').select(); "),
    Pid ! {message, Username, Message}.

    loop(Counter) ->
        wf:info("loop ok"),
        receive inc -> wf:info("F"),wf:update(counter, #span { body=wf:to_list(Counter) }), wf:flush(room2);
                U -> wf:info("U:~p",[U]) end, loop(Counter+1).

chat_loop() ->
    receive
        {message, Username, Message} ->
            error_logger:info_msg("Comet received : ~p",[{Username,Message}]),
            Terms = message(Username,Message),
            wf:insert_top(<<"history">>, Terms),
            wf:wire(#jq{target=history,property=scrollTop,right=#jq{target=history,property=scrollHeight}}),
%            wf:wire("$('#history').scrollTop = $('#history').scrollHeight;"),
            wf:send(lobby,{add,{Username,Message}}),
            wf:flush(room);
        Unknown -> error_logger:info_msg("Unknown Looper Message ~p in Pid: ~p",[Unknown,self()])
    end, chat_loop().

