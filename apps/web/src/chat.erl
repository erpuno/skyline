-module(chat).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/user.hrl").

main() -> 
  [ #dtl{file = wf:cache(mode), ext="dtl", bindings=[{title,<<"Login">>},{body,body()}]} ].

message(undefined,What) -> message("Anonymous",What);
message(Who,What) ->
    error_logger:info_msg("~p",[What]),
  #panel{class=["media"],body=[
      #link{class=["pull-left"], body=[
          #image{class=["media-object"],image="static/img/infinity.png",width= <<"63">>} ]},
            #panel{class=["media-body"],body=[
                #h4{body= unicode:characters_to_binary(Who)},
                #span{body=wf:js_escape(What)} ]} ]}.

body() ->
    {ok,Pid} = wf:async("looper",fun() -> chat_loop() end),
    index:header() ++ [
  #panel{class=["container-fluid", chat], body=[
    #panel{class=["row-fluid"], body=[
      #h1{body= <<"N2O based WebSocket Chat">>,class=[offset3, span8]}
    ]},
    #panel{class=["row-fluid"], body=[
      #panel{class=[span3], body=[
        #h4{body= "Online Users:" },
        #list{class=[unstyled, "chat-rooms"], body=[ 
          #li{body=#link{body= io_lib:format("~p",[Z])}} || {X,Y,Z} <- qlc:e(gproc:table()), X=={p,l,broadcast} 
           ]} ]},
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
  ]}

  ] ++ index:footer().


event({inc,Pid}) -> 
    {Headers,Req} = wf:headers(?REQ),
    Host = lists:keyfind(<<"host">>,1,Headers),
    wf:info(?MODULE,"Headers: ~p",[Headers]),
    wf:info(?MODULE,"Host: ~p",[Host]),
    wf:info("Inc"),
    Pid ! inc;

event(init) ->
    Self = self(),
    wf:reg(room),
    wf:send(lobby,{top,5,Self}),
    Terms = wf:render(receive Top -> [ message(U,M) || {U,M} <- Top] end),
    wf:insert_top(<<"history">>, #panel{body=[Terms]}),
    wf:wire("$('#history').scrollTop = $('#history').scrollHeight;");

event({chat,Pid}) ->
    Username = case wf:user() of undefined -> "anonymous"; A -> A#user.id end,
    Message = wf:q(message),
    Terms = [ message("Systen","Message added"), #button{postback=hello} ],
    wf:wire("$('#message').focus(); $('#message').select(); "),
    Pid ! {message, Username, Message}.

chat_loop() ->
    receive
        {message, Username, Message} ->
            error_logger:info_msg("Comet received : ~p",[{Username,Message}]),
            Terms = message(Username,Message),
            wf:insert_top(<<"history">>, Terms),
            wf:send(lobby,{add,{Username,Message}}),
            wf:flush(room);
        Unknown -> error_logger:info_msg("Unknown Looper Message ~p in Pid: ~p",[Unknown,self()])
    end, chat_loop().

