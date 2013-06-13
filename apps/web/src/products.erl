-module(products).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").

-define(PAGE_SIZE, case wf:session(page_size) of list -> 4; _ -> 8 end).

main()->
  fill_prods(),
  #dtl{file="dev", bindings=[{title,<<"products">>},{body, body()}]}.

body()->
  wf:session(page_size, list),
  wf:wire("$('#listsw').on('click', function(){ $('#products').addClass('items-list').removeClass('items-grid'); });"),
  wf:wire("$('#gridsw').on('click', function(){ $('#products').removeClass('items-list').addClass('items-grid'); });"),
  index:header() ++ [
  #panel{class=[container], body=[
    #carousel{class=["product-carousel", "top"], items= [product:product(P) || P <-[product:product()], _I <- lists:seq(1,3) ]},
    #panel{class=["btn-toolbar"],body=[
      #panel{class=["btn-group"], body=[
        #link{id=listsw, class=[btn, active], body=#i{class=["icon-th-list"]}, postback=to_list },
        #link{id=gridsw, class=[btn], body=#i{class=["icon-th-large"]}, postback=to_grid } ]} ]},
    #list{id=products, class=[thumbnails, products], body=list_products(1)},
    #panel{class=["pagination pagination-centered"],body=[ #list{id=pagination, body=pagination(1)} ]}
  ]}
  ] ++ index:footer().

list_products(Page) -> [#li{body=product:product(P)} || P <- lists:sublist(wf:session(products), (Page-1) * ?PAGE_SIZE + 1, ?PAGE_SIZE)].

pagination(Page)->
  PageCount = (length(wf:session(products)) -1 ) div ?PAGE_SIZE + 1,
  [#li{class=[if Page==1-> "disabled"; true->[] end, "previous"],body=#link{class=["fui-arrow-left"], body= <<"&lsaquo;">>, postback={page, 1}, url="javascript:void(0);" }},
  [#li{class=if I==Page -> active;true->[] end,body=#link{id="pglink"++integer_to_list(I),body=integer_to_list(I), postback={page, I}, url="javascript:void(0);" }} 
    || I <- lists:seq(1, PageCount)],
   #li{class=[if PageCount==Page -> "disabled";true->[] end,"next"], body=#link{class=["fui-arrow-right"], body= <<"&rsaquo;">>, postback={page, PageCount},url="javascript:void(0);" }} ].

event(init) -> [];
event({page, Page})-> 
  wf:update(pagination, pagination(Page)),
  wf:update(products, list_products(Page));
event({product, Id})-> wf:redirect("/product?id=" ++ Id);
event(to_list)->
  wf:session(page_size, list),
  wf:update(products, list_products(1)),
  wf:update(pagination, pagination(1));
event(to_grid)->
  wf:session(page_size, grid),
  wf:update(products, list_products(1)),
  wf:update(pagination, pagination(1));

event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]).

fill_prods()->
  Prods = [
    #product{
      id=I,
      name = list_to_binary("Name " ++ integer_to_list(I)),
      categories= [1],
      description_short= <<"Description header ">>,
      description_long= <<"Very long description Very long description Very long description">>,
      image_small_url = "/static/img/item-bg.png",
      image_big_url="/static/img/item-bg.png",
      publish_start_date = calendar:local_time(),
      publish_end_date =  calendar:local_time(),
      price=1000,
      our_price=999,
      creation_date= calendar:local_time()}
    || I <- lists:seq(1,20)],
  wf:session(products, Prods).
