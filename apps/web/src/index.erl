-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").

main() -> 
%    case wf:user() of
%         undefined -> wf:redirect("login");
%         _ -> 
    Title = "Title",
    Body = "Body",
    [ #dtl{file = "index", bindings=[{title,Title},{body,Body}]} ].
%    <<"N2O">>. 

body() -> %% area of http handler
    {ok,Pid} = wf:comet(fun() -> chat_loop() end), 
    wf:wire(#api{name=apiOne,tag=d1}),
  [
    #span { body= <<"Your chatroom name: ">> }, 
    #textbox { id=userName, body= wf:user() }, #button{body="Logout",postback=logout}, #br{},
    #panel { id=chatHistory },
    #button{id=but,body= <<"Click Me!">>,postback=change_me},
    #button{id=replace,body= <<"Replace Body">>,postback=replace},
    "<a onclick=\"document.apiOne('Hello')\" name='1'>API</a>",
    #textbox { id=message },
    #button { id=sendButton, body= <<"Chat">>, postback={chat,Pid}, source=[userName,message] },
    #panel { id=n2ostatus }
 ].

header()-> header(false).
header(Inverse) -> [
  #panel{class=[navbar, "navbar-fixed-top", if Inverse==true->"navbar-inverse"; true-> "" end, "sky-navbar"], body=[
    #panel{class=["navbar-inner"], body=[
      #panel{class=[container], body=[
        #link{class=[btn, "btn-navbar"], data_fields=[{<<"data-toggle">>, <<"collapse">>}, {<<"data-target">>, <<".nav-collapse">>}], url="javascript:void(0)",
          body=[#span{class=["icon-bar"]}||_I<-lists:seq(1,3)]},

        #h1{class=[brand], body=#link{url="/login", body= <<"Synrc App Store">>, name="top" }},
        #panel{class=["nav-collapse", "collapse"], body=[
          #list{class=[nav, "pull-right"], body=[
            #li{body=#link{url="/chat",body=[ #i{class=["icon-comment"]}, #span{class=["badge badge-info"], body="10"} ]}},
            #li{body=#link{url="/chat?mode=mail",body=[ #i{class=["icon-envelope"]}, #span{class=["badge badge-info"], body="21"} ]} },
            #li{body=#link{body=[ #i{class=["icon-search"]} ]}},
            #li{body=#link{body= <<"Home">>,url="/login"}},
            #li{body=#link{body= <<"Games">>,url="/products"}},
            #li{body=#link{body= <<"Review">>}},
            #li{body=[
              case wf:user() of
                undefined -> #link{id=login1, body= <<"Log in">>, postback=to_login, delegate=login};
                User -> #link{class=["dropdown-toggle", "avatar"],
                    %data_fields=[{<<"data-toggle">>, <<"dropdown">>}],
                    url="/account", body=[
                    case User#user.avatar of undefined-> ""; Img-> #image{class=["img-circle", "img-polaroid"], image=iolist_to_binary([Img,"?sz=50&width=50&height=50&s=50"]), width= <<"50px">>, height= <<"50px">>} end,
                    case User#user.display_name of undefined -> []; N -> N end]} end,
              #button{id="style-switcher", class=[btn, "btn-inverse", "dropdown-toggle", "account-link"], data_fields=[{<<"data-toggle">>, <<"dropdown">>}], body=#i{class=["icon-cog"]}},
              #list{class=["dropdown-menu"], body=[
                #li{body=#link{body=[#i{class=["icon-cog"]},  <<" Preferences">>]}},
                #li{body=#link{postback=chat,body=[#i{class=["icon-cog"]},  <<" Notifications">>]}},
                case wf:user() of
                  undefined -> #li{body=#link{id=loginbtn, postback=to_login, delegate=login, body=[#i{class=["icon-off"]}, <<" Login">> ]}};
                  _A -> #li{body=#link{id=logoutbtn, postback=logout, delegate=login, body=[#i{class=["icon-off"]}, <<" Logout">> ] }} end ]} ]} ]} ]} ]} ]} ]} ].

footer()-> [
  #footer{id=mainfooter, class=[section, "sky-footer"], body=
    #panel{class=["row-fluid"], body=[
          #panel{class=[span5, "footer-banner"], body=[
            #h3{body= <<"Synrc Research Center">>},
            #p{body = <<"Feel free to share your thoughts on Voxoz, Erlang, PaaS and other things.">>},
            #list{class=[icons], body=[
              #li{body=[#i{class=["icon-github", "icon-2x"]}, #link{url= <<"https://github.com/synrc">>, body= <<"Synrc Repositories">>}]}
            ]},
            #list{class=[unstyled], body=[
              #li{body= <<" &copy; 2013 Synrc Research Center s.r.o.">>},
              #li{body= <<" Roh&#225;&#269;ova 141/18, Praha 3 13000, Czech Republic">>},
              #li{body= <<" HQ: Chokolivsky blvd, 19A, off. 8, Kyiv, Ukraine">>}
            ]}
          ]},
          #panel{class=[span2], body=[
            #h3{body= <<"voxoz">>},
            #list{class=[unstyled], body=[
              #li{body=#link{url= <<"http://voxoz.com">>, body= <<"How it works">>}},
              #li{body=#link{url= <<"http://voxoz.com/pricing.html">>, body= <<"Pricing">>}},
              #li{body=#link{url= <<"http://voxoz.com">>, body= <<"Applications">>}}
            ]}
          ]},
          #panel{class=[span5], body=[
            #h3{body= <<"Recent news">>},
            #list{class=[unstyled], body=[
              #li{body=[#h3{body=[#link{url= <<"http://voxoz.com/">>, body= <<"First Erlang PaaS">>}]}, #p{body= <<"Jun 12, 2013">>}]},
              #li{body=[#h3{body=[#link{url= <<"http://synrc.com/framework/web">>, body= <<"N2O: Fastest Erlang Web Framework">>}]}, #p{body= <<"May 1, 2013">>}]} ]} ]} ]} }].

api_event(Name,Tag,Term) -> error_logger:info_msg("Index Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).

event(init) ->
  User = wf:user(),
   error_logger:info_msg("User: ~p",[User]),
  [ begin
          Terms = [ #span { body= [[208,188,208,176,208,186,209,129,208,184,208,188]] }, ": ",
                      #span { body=integer_to_list(N) }, #br{} ],
            wf:insert_bottom(chatHistory, Terms)
            end || N <- lists:seq(1,3) ];

event(change_me) ->
    wf:replace(but,
        #link{
            url= <<"http://erlang.org">>,
            body= <<"Here's Erlang">>,
            actions=#show{effect=fade}
        }
    );

event(replace) ->
    wf:wire(#redirect{url="hello",nodrop=false});

event({chat,Pid}) -> %% area of websocket handler
    error_logger:info_msg("Chat Pid: ~p",[Pid]),
    Username = wf:user(),
    Message = wf:q(message),
    Terms = [ #span { body= <<"Message sent">> }, #br{} ],
    wf:insert_bottom(chatHistory, Terms),
    wf:wire("$('#message').focus(); $('#message').select(); "),
    wf:reg(room),
    Pid ! {message, Username, Message};

event(Event) -> error_logger:info_msg("Event: ~p", [Event]).

chat_loop() -> %% background worker ala comet
    receive 
        {message, Username, Message} ->
            Terms = [ #span { body=Username }, ": ",
                      #span { body=Message }, #br{} ],
            wf:insert_bottom(chatHistory, Terms),
            wf:wire("$('#chatHistory').scrollTop = $('#chatHistory').scrollHeight;"),
            wf:flush(room); %% we flush to websocket process by key
        Unknown -> error_logger:info_msg("Unknown Looper Message ~p",[Unknown])
    end,
    chat_loop().
