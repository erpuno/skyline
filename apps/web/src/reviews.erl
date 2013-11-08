-module(reviews).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/feeds.hrl").
-include_lib("kvs/include/membership.hrl").

main() -> [#dtl{file = wf:cache(mode), ext="dtl", bindings=[{title,<<"Reviews">>},{body,body()}]}].

body() -> index:header() ++ [
  #section{id=content, body=
    #panel{class=[container], body=
      #panel{class=[row, dashboard], body=[
        #panel{class=[span3], body=dashboard:sidebar_menu(reviews)},
        #panel{class=[span9], body=dashboard:section(feed(wf:user()), "icon-list")}]}}}
  ] ++ index:footer().

feed(User) -> [
  #h3{body= <<"your reviews">>},
  #panel{class=["btn-toolbar"], body=[#link{class=[btn, "btn-large", "btn-success"], body= <<"Create New Box">>}]},

  #table{class=[table, "table-hover", containers],
    header=[ #tr{cells=[
      #th{body= <<"ID">>},
      #th{body= <<"Host">>},
      #th{body= <<"Pass">>},
      #th{body= <<"Region">>},
      #th{body= <<"SSH">>},
      #th{body= <<"action">>}]} ],
    body=[[
      #tr{class=[success], cells=[
        #td{body= <<"1d3e102378f9">>},
        #td{body= <<"sncn1">>},
        #td{body= <<"pass">>},
        #td{body= <<"do1.synrc.com">>},
        #td{body= <<"49153">>},
        #td{body=#link{class=[btn],body= <<"Stop">>}} ]},
      #tr{class=[error], cells=[
        #td{body= <<"0515e2b20bac">>},
        #td{body= <<"sncn2">>},
        #td{body= <<"pass">>},
        #td{body= <<"do1.synrc.com">>},
        #td{body= <<"49154">>},
        #td{body=#link{class=[btn], body= <<"Start">>}} ]} ]]}
  ].

event(init) -> [];
event({counter,C}) -> wf:update(onlinenumber,wf:to_list(C)).
api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), ok.
