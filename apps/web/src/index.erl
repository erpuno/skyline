-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/user.hrl").
-include_lib("nitro/include/nitro.hrl").


log_modules() -> [index,login,chat].

main() ->  [ #dtl{file = wf:cache(mode), ext="dtl", bindings=[{title,<<"Index">>},{body,body()}]} ].

body() ->
    index:header()
    ++ [#panel{style="font-size:38pt;height:200px;text-align: center;margin-top:200px;",
                body="Hello, N2O!"}]
    ++ index:footer().

account() ->
    #li{body=[
        case wf:user() of
             undefined -> #link{id=login1, body= <<"Login">>, postback=to_login, delegate=login};
             User -> #link{class=["dropdown-toggle", "avatar"], url="/account", body=[
                           case User#user.avatar of 
                                undefined -> "";
                                Img -> #image{class=["img-circle", "img-polaroid"], 
                                              image=iolist_to_binary([Img,"?sz=50&width=50&height=50&s=50"]), 
                                              width= <<"50px">>, height= <<"50px">>} end,
                           case User#user.display_name of undefined -> []; N -> N end]} end,
        #button{id="style-switcher", class=[btn, "btn-inverse", "dropdown-toggle", "account-link"], 
                data_fields=[{<<"data-toggle">>, <<"dropdown">>}], body=#i{class=["icon-cog"]}},
        #list{class=["dropdown-menu"], body=[
            #li{body=#link{body=[#i{class=["icon-cog"]},  <<" Preferences">>]}},
            #li{body=#link{postback=chat,body=[#i{class=["icon-cog"]},  <<" Notifications">>]}},
            case wf:user() of
                 undefined -> #li{body=#link{id=loginbtn, postback=to_login, delegate=login, 
                                             body=[#i{class=["icon-off"]}, <<" Login">> ]}};
                 _A -> #li{body=#link{id=logoutbtn, postback=logout, delegate=login, 
                                      body=[#i{class=["icon-off"]}, <<" Logout">> ] }} end ]} ]}.

header() -> [{_,C}]= ets:lookup(globals,onlineusers), [ #dtl{file = "hd", ext="dtl", bindings=[{account,account()},{online,C}]} ].
footer() -> [ #dtl{file = "tl", ext="dtl", bindings=[]} ].

api_event(Name,Tag,Term) -> error_logger:info_msg("Index Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).
event({counter,C}) -> wf:update(onlinenumber,wf:to_list(C));
event(Event) -> 
    wf:info(?MODULE,"Context: ~p",[wf_context:context()]),
    error_logger:info_msg("Event: ~p", [Event]).
