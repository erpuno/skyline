-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").

main() -> 
    case wf:user() of
         undefined -> wf:redirect("login");
         _ -> Title = "Title",
              Body = "Body",
              [ #dtl{file = "prod", ext="dtl", bindings=[{title,Title},{body,Body}]} ] end.

body() -> [].

account() ->
    #li{body=[
        case wf:user() of
             undefined -> #link{id=login1, body= <<"Log in">>, postback=to_login, delegate=login};
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

header() -> [ #dtl{file = "hd", ext="dtl", bindings=[{account,account()}]} ].
footer() -> [ #dtl{file = "tl", ext="dtl", bindings=[]} ].

api_event(Name,Tag,Term) -> error_logger:info_msg("Index Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).
event(Event) -> error_logger:info_msg("Event: ~p", [Event]).
