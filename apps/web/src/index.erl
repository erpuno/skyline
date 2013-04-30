-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> #template { file= code:priv_dir(web) ++ "/templates/index.html" }.
title() -> <<"N2O">>.

body() -> % area of http handler
    {ok,Pid} = wf:comet(fun() -> chat_loop() end),
  [ #span { text= <<"Your chatroom name: ">> }, 
    #textbox { id=userName, text= <<"Anonymous">>, style= <<"width: 100px;">>, next=messageTextBox },
    #panel { id=chatHistory, class=chat_history },
    #textbox { id=message, style= <<"width: 70%;">>, next=sendButton },
    #button { id=sendButton, text= <<"Send">>, postback={chat,Pid}, source=[userName,message] },
    #panel { id=status } ].

event({chat,Pid}) -> % area of websocket handlers
    error_logger:info_msg("Looper Pid ~p",[Pid]),
    Username = wf:q(userName),
    Message = wf:q(message),
    Terms = [ #span { text="Message sent" }, #br{} ],
    wf:insert_bottom(chatHistory, Terms),
    wf:wire("$('#message').focus(); $('#message').select(); "),
    wf:reg_pool(room),
    Pid ! {message, Username, Message};

event(Event) -> error_logger:info_msg("Event: ~p", [Event]).

chat_loop() -> % background worker
    receive 
        {message, Username, Message} ->
            Terms = [ #span { text=Username }, ": ",
                      #span { text=Message }, #br{} ],
            wf:insert_bottom(chatHistory, Terms),
            wf:wire("$('#chatHistory').scrollTop = $('#chatHistory').scrollHeight;"),
            wf:flush(room);
%           wf:flush(Pid); % we flush to websocket processes
        Unknown -> error_logger:info_msg("Unknown Looper Message ~p",[Unknown])
    end,
    chat_loop().
