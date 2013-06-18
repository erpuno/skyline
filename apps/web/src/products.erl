-module(products).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include("records.hrl").

-define(PAGE_SIZE, case wf:session(page_size) of list -> 6; _ -> 8 end).

main()->
  wf:session(products, [product:product(I, 2) || I <- lists:seq(1,20)] ),
  wf:session(page_size, list),
  #dtl{file="dev", bindings=[{title,<<"products">>},{body, body()}]}.

body()->
%  wf:wire("$('#listsw').on('click', function(){ $('#products').removeClass('items-grid').addClass('items-list').children('li').addClass('span3').removeClass('span4'); });"),
%  wf:wire("$('#gridsw').on('click', function(){ $('#products').removeClass('items-list').addClass('items-grid').children('li').addClass('span4').removeClass('span3'); });"),
  index:header() ++ [
  #panel{id=content, body=[
    #section{class=[section, alt], body=#panel{class=[container], body=
      #carousel{class=["product-carousel"], items=[#product_figure{product=product:product(I,1)} || I <- lists:seq(1,2)] }}},
    #section{class=[section], body=[
      #panel{class=[container], body=[
        #panel{class=["page-header", "thumbnail-filters"], body=[#h1{body=[
          <<"Categories">>,
          #small{body=[[<<" / ">>, #link{data_fields=[{<<"data-filter">>, C}], body=C}] || {C, _D} <- categories() ]}
        ]} ]},
        #list{id=products, class=[thumbnails, bordered, "thumbnail-list", products, "items-list"], body=list_products(1)},
        #panel{class=["pagination pagination-centered"],body=[ #list{id=pagination, body=pagination(1)} ]}
      ]}
    ]},
    #section{class=[section, alt], body=#panel{class=[container], body=[
      #panel{class=["hero-unit", "text-center"], body=[
        #h1{body= <<"Got a question?">>},
        #p{body= <<"want to work with us to move your bussines to the next level? Well, dont be afraid">>},
        #link{class=[btn, "btn-large", "btn-info"], body= <<"contact us">>}
      ]}
    ]}}
  ]}] ++ index:footer().

categories() ->
  [{<<"Action">>, <<"abababab">>}, {<<"Shooting">>, <<"shooting">>}, {<<"Sports">>, <<"bla-bla">>}, {<<"Role-Playing">>, <<"abababab">>}, {<<"Strategy">>, <<"bla-bla">>}].

list_products(Page) -> [#li{class=[span4], body=#product_figure{product=P}} || P <- lists:sublist(wf:session(products), (Page-1) * ?PAGE_SIZE + 1, ?PAGE_SIZE)].

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
