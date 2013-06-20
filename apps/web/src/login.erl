-module(login).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "prod", bindings=[{title,<<"Login">>},{body, body()}]} ].

body() -> 
  index:header() ++ [
  #panel{id="content", role="main", class=["theme-pattern-lightmesh", alt], body=[
  #section{class=[section], id=promo, body=[
  #panel{class=[container], body=[
    #panel{class=[modal, "modal-login"], body=[ 
      #panel{class=["form-horizontal"], id=loginform, body=[
        #panel{class=["modal-header"], body=[
          #button{class=[close], data_fields=[{<<"data-dismiss">>,<<"modal">>}], aria_states=[{<<"aria-hidden">>, <<"true">>}], body= <<"&times;">>},
          #h3{body= <<"Log in to your account">>}
        ]},
        #panel{class=["modal-body"], body=[
          #panel{id=messages, body=[]},
          #h3{class=["text-center"], body= <<"Sign in with">>},
          #panel{class=["btn-toolbar", "text-center"], body=[
            #panel{class=["btn-group"], body=#link{class=[btn, "btn-info", disabled], body=[#i{class=["icon-twitter"]}, <<" Twitter">>]}},
            #panel{class=["btn-group"], body=#link{class=[btn, "btn-primary", disabled], body=[#i{class=["icon-facebook"]}, <<" Facebook">>]}},
            #panel{class=["btn-group"], body=#link{class=[btn, "btn-danger", disabled], body=[#i{class=["icon-google-plus"]}, <<" Google">>]}}
          ]},
          #h3{class=["text-center"], body= <<"or">>},
          #panel{class=["control-group"], body=[
            #label{class=["control-label"], for=user, body= <<"Username">>},
            #panel{class=[controls], body=[
              #panel{class=["input-prepend"], body=[
                #span{class=["add-on"], body=#i{class=["icon-user"]}},
                #textbox{id=user, placeholder= <<"username">>, data_fields=[{<<"data-original-title">>, <<"">>}]}
              ]}
            ]}
          ]},
          #panel{class=["control-group"], body=[
            #label{class=["control-label"], for=pass, body= <<"Password">>},
            #panel{class=[controls], body=[
              #panel{class=["input-prepend"], body=[
                #span{class=["add-on"], body=#i{class=["icon-lock"]}},
                #password{id=pass, data_fields=[{<<"data-original-title">>, <<"">>}]}
              ]}
            ]}
          ]},
          #panel{class=["control-group"], body=[
            #panel{class=[controls], body=[
              #checkbox{id=remember, class=["checkbox"], checked=checked, body="Remember me"}
            ]}
          ]}

        ]},
        #panel{class=["modal-footer"], body=[
          #link{class=["pull-left", "link-forgot"], body= <<"forgot password?">>},
          #button{id=login, class=[btn, "btn-info"], body= <<"Sign in">>, postback=login, source=[user,pass]}
        ]}
      ]}
    ]},
    #panel{class=["pull-center"], body=[<<"Not a member?">>, #link{body= <<" Sign Up">>} ]} ]} ]} ]} ] ++ index:footer().


api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p~n, Tag ~w~n, Term ~p",[Name,Tag,Term]).

event(init) -> [];
event(chat) -> wf:redirect("chat");
event(to_login) -> wf:redirect("login");
event(login) -> User = wf:q(user), wf:update(display,User), wf:user(User), wf:redirect("/chat").



