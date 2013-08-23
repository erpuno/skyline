-module(login).
-compile(export_all).
-include_lib("avz/include/avz.hrl").
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").

main() ->
  avz:callbacks(?METHODS),
  [#dtl{file = "prod",  ext="dtl",bindings=[{title,<<"Login">>},{body, body()}]} ].

body() ->
  index:header() ++ [
  #panel{id="content", role="main", class=["theme-pattern-lightmesh", alt], body=[
  #section{class=[section], id=promo, body=[
  #panel{class=[container], body=[
    #panel{class=[modal, "modal-login"], body=[ 
      #panel{class=["form-horizontal"], id=loginform, body=[
        #panel{class=["modal-header"], body=[
          #button{class=[close], data_fields=[{<<"data-dismiss">>,<<"modal">>}], 
                                 aria_states=[{<<"aria-hidden">>, <<"true">>}], body= <<"&times;">>},
          #h3{body= <<"Log in to your account">>} ]},
        #panel{class=["modal-body"], body=[
          #panel{id=messages, body=[]},
          #h3{class=["text-center"], body= <<"Sign in with">>},
          #panel{class=["btn-toolbar", "text-center"], body=[
            avz:buttons(?METHODS) ]},
          #h3{class=["text-center"], body= <<"or">>},
          #panel{class=["control-group"], body=[
            #label{class=["control-label"], for=user, body= <<"Email">>},
            #panel{class=[controls], body=[
              #panel{class=["input-prepend"], body=[
                #span{class=["add-on"], body=#i{class=["icon-user"]}},
                #textbox{id=user, placeholder= <<"e-mail">>, data_fields=[{<<"data-original-title">>, <<"">>}]} ]} ]} ]},
          #panel{class=["control-group"], body=[
            #label{class=["control-label"], for=pass, body= <<"Password">>},
            #panel{class=[controls], body=[
              #panel{class=["input-prepend"], body=[
                #span{class=["add-on"], body=#i{class=["icon-lock"]}},
                #password{id=pass, data_fields=[{<<"data-original-title">>, <<"">>}]} ]} ]} ]},
          #panel{class=["control-group"], body=[
            #panel{class=[controls], body=[
              #checkbox{id=remember, class=["checkbox"], checked=checked, body="Remember me"} ]} ]} ]},
        #panel{class=["modal-footer"], body=[
          #link{class=["pull-left", "link-forgot"], body= <<"forgot password?">>},
          #button{id=login, class=[btn, "btn-info", "btn-large"], body= <<"Sign in">>, postback=login, source=[user,pass]} ]} ]} ]},
    #panel{class=["pull-center"], body=[<<"Not a member?">>, #link{body= <<" Sign Up">>} ]} ]} ]} ]} ] 
    ++ index:footer() ++ avz:sdk(?METHODS) .

event(X) -> avz:event(X).
api_event(X,Y,Z) -> avz:api_event(X,Y,Z).
