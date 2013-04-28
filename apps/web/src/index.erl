-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> #template { file= code:priv_dir(web) ++ "/templates/index.html" }.
title() -> <<"N2O">>.

body() -> %spawn(fun() -> chat_loop() end),
  [
    #span { text= <<"Your chatroom name: ">> }, 
    #textbox { id=userNameTextBox, text= <<"Anonymous">>, style= <<"width: 100px;">>, next=messageTextBox },
    #panel { id=chatHistory, class=chat_history },
    #textbox { id=messageTextBox, style= <<"width: 70%;">>, next=sendButton },
    #button { id=sendButton, text= <<"Send">>, postback=chat },
    #panel { id=status } ].

event(chat) ->
    error_logger:info_msg("Button Pressed"),
%    Username = wf:q(userNameTextBox),
%    Message = wf:q(messageTextBox),
%    wf:push({message, Username, Message}),
            Terms = [
                #p{},
                #span { text="You are the only person in the chat room.", class=message }
            ],
    wf:insert_bottom(chatHistory, Terms),
    wf:wire("$('#messageTextBox').focus(); $('#messageTextBox').select(); "),
    ok;

event(Event) -> error_logger:info_msg("Event: ~p", [Event]).

chat_loop() ->
    receive 
        {message, Username, Message} ->
            Terms = [
                #span { text=Username, class=username }, ": ",
                #span { text=Message, class=message }
            ],
            wf:insert_bottom(chatHistory, Terms),
            wf:wire("$('#chatHistory').scrollTop = $('#chatHistory').scrollHeight;"),
            wf:flush()
    end,
    chat_loop().
