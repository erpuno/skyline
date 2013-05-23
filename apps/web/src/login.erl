-module(login).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

title() -> [ <<"Login">> ].

main() ->
    Title = wf:render(title()),
    Body = wf:render(body()),
  [ #dtl{file = "tblist", bindings=[{title,Title},{body,Body}]} ].

body() -> [ #span{id=display},
            #panel{class=["container"], body=[
            #panel{style=["padding: 38px 38px 267px;"], body=[
            #panel{class=["login-screen"], body=[
              #panel{class=["login-form"],body=[
                 #panel{class=["control-group"],body=[
                     #label{class=["fui-lock"],text="Login: ",for=user},
                     #textbox{id=user,class=["login-field"]}
                 ]},
                 #panel{class=["control-group"],body=[ 
                     #label{class=["fui-lock"],text="Password: ",for=pass},
                     #password{id=pass,class=["login-field"]}
                 ]},
               #button{class=["btn","btn-primary","btn-large","btn-block"],text="Login",postback=login,source=[user,pass]}

               ]} ]} ]} ]}
  ].

event(init) -> [];

event(login) -> User = wf:q(user), wf:update(display,User), wf:user(User), wf:redirect("index").
