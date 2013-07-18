-module(account).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").

main() -> case wf:user() of undefined -> wf:redirect("/login"); _ -> [#dtl{file = "prod",  ext="dtl",bindings=[{title,<<"Account">>},{body,body()}]}] end.

body() -> index:header() ++ [
  #section{id=content, body=
    #panel{class=[container], body=
      #panel{class=[row, dashboard], body=[
        #panel{class=[span3], body=dashboard:sidebar_menu(account)},
        #panel{class=[span9], body=[
          dashboard:section(profile_info(wf:user()), "icon-user"),
          dashboard:section(ballance(wf:user()), "icon-ok-sign"),
          dashboard:section(payments(wf:user()), "icon-list") ]} ]} } }
  ] ++ index:footer().

profile_info(U) -> 
      {{Y, M, D}, _} = calendar:now_to_datetime(U#user.register_date),
      RegDate = io_lib:format("~p ~s ~p", [D, element(M, {"Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"}), Y]),
      Mailto = if U#user.email==undefined -> []; true-> iolist_to_binary(["mailto:", U#user.email]) end,
      [
      #h3{class=["text-left"], body= <<"Profile">>},
      #panel{class=["row-fluid"], body=[
        #panel{class=[span4, "dashboard-img-wrapper"], body=
        #panel{class=["dashboard-img"], body=
          #image{class=[], alt="",
            image = re:replace(U#user.avatar, <<"_normal">>, <<"">>, [{return, list}]) ++"?sz=180&width=180&height=180&s=180", width= <<"180px">>, height= <<"180px">> }} },
      #panel{class=[span8, "profile-info-wrapper"], body=
        #panel{class=["form-inline", "profile-info"], body=[
        #panel{body=[#label{body= <<"Name:">>}, #b{body= iolist_to_binary([U#user.name, " ", U#user.surname])}]},
        #panel{show_if=U#user.email=/=undefined, body=[#label{body= <<"Mail:">>}, #link{url= Mailto, body=#strong{body= U#user.email}}]},
        #panel{body=[#label{body= <<"Member since ">>}, #strong{body= RegDate}]},
        #b{class=["text-success"], body= <<"Active">>} ]}}]}].

ballance(User) -> [
  #h3{body= <<"Balance">>},
  #panel{class=["row-fluid"], body=[
    #panel{class=[span4, "text-center", "ballance-label"], body=[
      #b{class=[positive], body= <<"+30.0">>},
      #span{body= <<"Credit">>}]},
    #panel{class=[span3, "text-center", "ballance-label"], body=[
      #b{class=[negative], body= <<"-0.82">>},
      #span{body= <<"Debit">>}]},
    #panel{class=[span4, "text-center"], body=[#link{class=[btn, "btn-large", "btn-success", "btn-charge"], body= <<"Charge">>}]},
    #panel{class=[span1]}]}].

payments(User) -> [
  #h3{body= <<"Payments">>},
  #table{class=[table, "table-hover", payments], rows=[
    #tr{cells= [
      #td{body= <<"27 Jun 2013">>},
      #td{body= <<"Charge">>},
      #td{body= <<"-$0.82">>},
      #td{body=#link{body= <<"sncn1">>}} ]},
    #tr{cells= [
      #td{body= <<"26 Jun 2013">>},
      #td{body= <<"Payment">>},
      #td{body= <<"$30">>},
      #td{body= <<"">>} ]} ]} ].

api_event(Name,Tag,Term) -> error_logger:info_msg("dashboard Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]).
event(init) -> [].
