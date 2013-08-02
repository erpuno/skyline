-module(prods).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include_lib("kvs/include/membership.hrl").

-record(product_row, {?ELEMENT_BASE(prods), product=[]}).

main() -> case wf:user() of 
  undefined -> wf:redirect("/login"); 
  _ -> [#dtl{file = "dev", ext="dtl", bindings=[{title,<<"Products">>},{body,body()}]}] end.

body() -> 
  wf:wire(#api{name=uploaded, tag=product_title}),
  index:header() ++ [
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
      #textarea{id=brief, class=[span12], placeholder= <<"Brief">>, rows="2"}
%      #textarea{id=descr, class=[span12], placeholder= <<"Description">>, rows="6"}
    ]},
    #panel{class=[span2], body=[
      #upload{id=front, delegate=prods, root=code:priv_dir(web)++"/static"},
      #select{id=category, multiple=true, body=[
        #option{value=shooter, body= <<"Shooter">>},
        #option{value=rpg, body= <<"RPG">>}
      ]}
    ]}
  ]},
  #panel{class=["btn-toolbar"], body=[#link{id=save, postback=save, source=[title, brief, category], class=[btn, "btn-large", "btn-success"], body= <<"Create">>}]} ].

products_table() -> [
  #h3{body= <<"your products">>},
  #table{id=products, class=[table, "table-hover"], body=[[#product_row{product=P} || P <- kvs:all(product)]] }  ].

event(init) -> [];
event(save) ->
  wf:session(xyu, [xyu, xyu]),
  error_logger:info_msg("Save product ~p ~p ~p", [wf:q(title), wf:q(brief), wf:q(category)]),
  User = wf:user(),
  Title = wf:q(title),
  Descr = wf:q(brief),
  Categories = [1],%wf:q(category),
  TitlePic = wf:session(title_picture),
  Product = #product{
    creator= User#user.username,
    owner=User#user.username,
    title = Title,
    cover = TitlePic,
    brief = Descr,
    categories = Categories,
    price = 59.95
  },

  case kvs_products:register(Product) of
    {ok, P} -> P,
      wf:session(title_picture, undefined),
      error_logger:info_msg("?~p", [wf:render(#product_row{product=P})]),
      wf:wire(wf:f("$('#products > tbody:first').after('~s')", [binary_to_list(wf:render(#product_row{product=P})) ]));
    E -> error_logger:info_msg("E: ~p", [E]), error
  end.

api_event(uploaded, Args, _Term) ->
  Pic = re:replace(Args, "\\\"", [], [global, {return, list}]),
  error_logger:info_msg("Uploaded ~p", [Pic]),
  wf:session(title_picture, Pic),
  ok;
api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), ok.

control_event(Cid, {File, Data, ActionHolder}) ->
  error_logger:info_msg("Control ~p File ~p", [Cid, File]),
  Base = code:priv_dir(web),
  file:write_file(File, Data, [write, raw]),
  wf:wire(wf:f("uploaded('~s');", [File--Base])),
  wf:flush(ActionHolder),
  ok.


render_element(#product_row{product=P}) ->
  Row = #tr{cells=[
    #td{body= integer_to_list(P#product.id)},
    #td{body= #link{class=[], url="/prod?id="++integer_to_list(P#product.id), body=P#product.title}},
    #td{body= P#product.brief}
  ]},
  element_tr:render_element(Row).
