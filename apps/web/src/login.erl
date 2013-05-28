-module(login).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "prod", bindings=[{title,<<"Login">>},{body,wf:render(body())}]} ].

body() -> store2:header() ++ [

    #panel{class=["login-icon"],body=[#image{image="static/flatui/images/illustrations/retina.png"}]},

%    #panel{class=["row-fluid"],body=[
    #h1{body=["N2O based Session Cookies Login"],class=[offset4],style="padding-left: 34px;"},
    #panel{class=[offset4,span8],body=[
        #panel{class=["well"],body=[
            #list{class=["nav nav-tabs"],body=[
                #li{class=["active"],body=[#link{url="#login_me",data_fields=[{<<"data-toggle">>,<<"tab">>}],body="Login"}]},
                #li{class=[],        body=[#link{url="#restore_me",data_fields=[{<<"data-toggle">>,<<"tab">>}],body="Restore Pass"}]} ]},
            #panel{class=["tab-content"],body=[
                #panel{class=[active,"tab-pane",in],id="login_me", body=[
                    #panel{class=["login-form"],body=[
                        #panel{class=["control-group"],body=[
                             #textbox{id=user,class=["login-field"],style="width:475px;"},
                             #label{class=["fui-user login-field-icon"],for=user} ]},
                        #panel{class=["control-group"],body=[ 
                             #password{id=pass,class=["login-field"],style="width:475px;"},
                             #label{class=[<<"login-field-icon">>,<<"fui-lock">>],body="",for=pass} ]},
                        #checkbox{id=remember, class=["checkbox"], checked=checked, body="Remember me"},
                        #button{id=login,style=["width: 215px;"],class=["btn","btn-primary","btn-large","btn-block"],body="Site Login",postback=login,source=[user,pass]},
                        #button{id=facebook,style=["margin-top: 10px; width: 215px;"],class=["btn","btn-primary","btn-large","btn-inverse"],body="Facebook Login",postback=facebooklogin,source=[]} ]} ]},
                #panel{class=[fade,"tab-pane"],id="restore_me",body=[
                    #panel{class=["login-form"],body=[
                        #panel{class=["control-group"],style="margin-bottom:15px;",body=[
                             #textbox{id=user,class=["login-field"],style="width:475px;"},
                             #label{class=["fui-user login-field-icon"],body="",for=user} ]},
                        #button{id=restore,style=["width: 215px;"],class=["btn","btn-primary","btn-large","btn-block"],body="Send Password",postback=login,source=[user,pass]} ]} ]} ]} ]} ]}
%    ]}
    ].

event(init) -> [];
event(chat) -> wf:redirect("chat");
event(to_login) -> wf:redirect("login");
event(login) -> User = wf:q(user), wf:update(display,User), wf:user(User), wf:redirect("chat").
