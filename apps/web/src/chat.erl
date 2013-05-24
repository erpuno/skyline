-module(chat).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "tblist", bindings=[{title,<<"Login">>},{body,wf:render(body())}]} ].

message(Who,What) ->
    #panel{class=["row"],body=[
        #panel{class=["media"],body=[
            #link{class=["pull-left"], body=[
                #image{class=["media-object"],image="static/flatui/images/illustrations/infinity.png",width= <<"63">>} ]},
            #panel{class=["media-body"],body=[
                #h4{text=Who},
                #span{text=What} ]} ]} ]}.

body() ->
    {ok,Pid} = wf:comet(fun() -> chat_loop() end),
    store2:header() ++ [
    #panel{class=span3,body=[
        #panel{class=[container,thumbnail],style="background-color: #f5f5f5; margin-top: 100px;",body=[
            #panel{class=row,body=[
                #panel{class=["media"],style="",body=[
                    #panel{class=["media-body"],body=[#b{text="doxtop"}]} ]},
                #panel{class=["media"],style="",body=[
                    #panel{class=["media-body"],body=[#b{text="maxim"}]}  ]} ]} ]} ]},
    #panel{class=span3,body=[
        #panel{id=history,class=[container,thumbnail],style="background-color: #f5f5f5; margin-top: 100px;",body=[
            case wf:user() of undefined -> message("System","You are not logged in. Anonymous mode!");
                              _ -> message("System","Hello, " ++ wf:user() ++ "! Here you can chat, please go on!") end ]},
        #textarea{id=message,style="display: inline-block; margin-top: 20px;"},
        #button{id=send,text="Send",class=["btn","btn-primary","btn-large","btn-inverse"],postback={chat,Pid},source=[message]} ]} ].

event(init) -> [];
event(logout) -> store2:event(logout);
event(to_login) -> wf:redirect("login");
event(login) -> User = wf:q(user), wf:user(User), wf:redirect("index");
event(chat) -> wf:redirect("chat");

event({chat,Pid}) ->
    error_logger:info_msg("Chat Pid: ~p",[Pid]),
    Username = case wf:user() of undefined -> "anonymous"; A -> A end,
    Message = wf:q(message),
    wf:wire("$('#message').focus(); $('#message').select(); "),
    wf:reg(room),
    Pid ! {message, Username, Message}.

chat_loop() ->
   receive
         {message, Username, Message} ->
             error_logger:info_msg("Comet received : ~p",[{Username,Message}]),
            Terms = message(Username,Message),
            wf:insert_bottom(<<"history">>, Terms),
            wf:wire("$('#history').scrollTop = $('#history').scrollHeight;"),
            wf:flush(room);
        Unknown -> error_logger:info_msg("Unknown Looper Message ~p",[Unknown])
    end, chat_loop().

