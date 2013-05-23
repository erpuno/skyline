-module(login).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "tblist", bindings=[{title,<<"Login">>},{body,wf:render(body())}]} ].

body() -> [

    #panel{class=[navbar, "navbar-inverse", "navbar-fixed-top"], body=[
        #panel{class=["navbar-inner"], body=[
            #panel{class=[container], body=[
                #link{class=[brand], url="#", text="Synrc App Store" }
            ]}
        ]}
    ]},

    #panel{class=["login-icon"],body=[#image{image="static/flatui/images/login/icon.png"}]},

    #panel{class=["login-screen"], style="height:100%;", body=[
        #panel{class=["modal-body"], style="overflow: hidden;",body=[
            #panel{class=["well"],body=[
                #list{class=["nav nav-tabs"],body=[
                    #li{class=["active"],body=[#link{url="#login_me",data_fields=["tab"],text="Login"}]},
                    #li{class=[],        body=[#link{url="#restore_me",data_fields=["tab"],text="Restore Pass"}]}
                ]},
                #panel{class=["tab-content"],body=[
                    #panel{class=[active,"tab-pane",in],id="login_me", body=[


                #panel{class=["login-form"],body=[
                #panel{class=["control-group"],style="margin:0px;",body=[
                     #textbox{id=user,class=["login-field"],style="width:425px;"},
                     #label{class=["fui-user login-field-icon"],style="margin-left:0px;",text="",for=user}
                ]},
                #panel{class=["control-group"],style="margin:0px;",body=[ 
                     #password{id=pass,class=["login-field"],style="width:425px;"},
                     #label{class=[<<"login-field-icon">>,<<"fui-lock">>],text="",for=pass}
                ]},
                #checkbox{id=remember, class=["checkbox"], checked=checked, text="Remember me"},
                #button{id=login,style=["width: 215px;"],class=["btn","btn-primary","btn-large","btn-block"],text="Site Login",postback=login,source=[user,pass]},
                #button{id=facebook,style=["margin-top: 10px; width: 215px;"],class=["btn","btn-primary","btn-large","btn-inverse"],text="Facebook Login",postback=facebooklogin,source=[]}
                ]}

                    ]},
                    #panel{class=[fade,"tab-pane"],id="restore_me",body=[

                #panel{class=["login-form"],body=[
                #panel{class=["control-group"],style="margin-bottom:15px;",body=[
                     #textbox{id=user,class=["login-field"],style="width:425px;"},
                     #label{class=["fui-user login-field-icon"],style="margin-left:0px;",text="",for=user}
                ]},
                #button{id=restore,style=["width: 215px;"],class=["btn","btn-primary","btn-large","btn-block"],text="Send Password",postback=login,source=[user,pass]}

                    ]}
                ]}
        ]}]}]}
    ]}
  ].

event(init) -> [];

event(login) -> User = wf:q(user), wf:update(display,User), wf:user(User), wf:redirect("index").
