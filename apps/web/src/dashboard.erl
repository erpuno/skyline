-module(dashboard).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

sidebar_menu(Page)->
  Lis = [#li{class=if Page==I->active;true->[]end, body=#link{url="/"++atom_to_list(I), body=T}}
    || {I, T} <- [{products, <<"products">>}, {reviews, <<"reviews">>}, {account, <<"account">>}]],
  #panel{class=["docs-sidebar-menu", "dash-sidebar-menu"], body=#list{class=[nav, "nav-list", "docs-sidebar-nav", "dash-sidebar-nav", "affix-top"],
    data_fields=[{<<"data-spy">>, <<"affix">>}],
    body=Lis}}.

section(Body, Icon) ->
  #section{class=["row-fluid", "dashboard-section"], body=[
    #panel{class=[span1], body=#i{class=[Icon, "icon-2x"]}},
    #panel{class=[span11, "dashboard-unit"], body=Body}
  ]}.