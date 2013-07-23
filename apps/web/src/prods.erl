-module(prods).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include_lib("kvs/include/attachments.hrl").
-include_lib("kvs/include/membership.hrl").

-record(product_row, {?ELEMENT_BASE(prods), product=[]}).

main() -> %case wf:user() of undefined -> wf:redirect("/login"); _ -> 
  [#dtl{file = "dev", ext="dtl", bindings=[{title,<<"Products">>},{body,body()}]}].
% end.

body() -> index:header() ++ [
  #section{id=content, body=
    #panel{class=[container], body=
      #panel{class=[row, dashboard], body=[
        #panel{class=[span3], body=dashboard:sidebar_menu(prods)},
        #panel{class=[span9], body=[
          dashboard:section(new_product(), "icon-plus-sign-alt"),
          dashboard:section(products_table(), "icon-list")]} ] }}}
  ] ++ index:footer().

new_product() -> [
  #h3{body="create product"},
  #panel{class=["row-fluid"], body=[
    #panel{class=[span10], body=[
      #textbox{id=title, class=[span12], placeholder= <<"Title">>},
      #textarea{id=descr, class=[span12], placeholder= <<"Description">>, rows="6"}
    ]},
    #panel{class=[span2], body=[
    ]}
  ]},
  #panel{class=["btn-toolbar"], body=[#link{id=save, postback=save, source=[title, descr], class=[btn, "btn-large", "btn-success"], body= <<"Create">>}]} ].

products_table() -> [
  #h3{body= <<"your products">>},
  #table{class=[table, "table-hover"], rows=[#product_row{product=P} || P <- kvs:all(product)]}  ].

event(init) -> [];
event(save) ->
  error_logger:info_msg("Save product ~p ~p", [wf:q(title), wf:q(descr)]),
  User = #user{username="doxtop"},
  Title = wf:q(title),
  Descr = wf:q(descr),
  Product = #product{
    creator= User#user.username,
    owner=User#user.username,
    title = Title,
    description = Descr,
    price = 59.95
  },

  case kvs_products:register(Product) of
    {ok, Product} -> Product;
    _ -> error
  end.

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), ok.

render_element(#product_row{product=P}) ->
  Row = #tr{cells=[
    #td{body= integer_to_list(P#product.id)},
    #td{body= #link{class=[], url="/prod?id="++integer_to_list(P#product.id), body=P#product.title}},
    #td{body= P#product.description}
  ]},
  element_tr:render_element(Row).
