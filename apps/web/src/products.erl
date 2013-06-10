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
    carousel(),
    #panel{class=["btn-toolbar"],body=[
      #panel{class=["btn-group"], body=[
        #link{id=listsw, class=[btn, active], body=#i{class=["icon-th-list"]}, postback=to_list },
        #link{id=gridsw, class=[btn], body=#i{class=["icon-th-large"]}, postback=to_grid } ]} ]},
    #list{id=products, class=[thumbnails, products], body=list_products(1)},
    #panel{class=["pagination pagination-centered"],body=[ #list{id=pagination, body=pagination(1)} ]}
  ]}
  ] ++ index:footer().

list_products(Page) -> [#li{body=product(P)} || P <- lists:sublist(wf:session(products), (Page-1) * ?PAGE_SIZE + 1, ?PAGE_SIZE)].

product(P)->
  #panel{class=[product, "row-fluid"], body=[
    #link{class=[span4,"product-image"], body=#image{class=["img-polaroid"], image=P#product.image_small_url}, postback={product, integer_to_list(P#product.id)} },
    #panel{class=[span2, "product-name"], body=[
      #h4{body = P#product.name},
      #link{url="#",body=[ #i{class=["icon-user"]}, #span{class=["badge badge-info"], body= <<"1024">>} ]},
      #link{url="#",body=[ #i{class=["icon-comment"]}, #span{class=["badge badge-info"], body= <<"10">>} ]} ]},
    #panel{class=[span3, "product-description"], body=[
      #h4{body = P#product.description_short},
      #p{body=P#product.description_long} ]},
    #panel{class=[span3, "product-price"], body=[
      #h2{body=list_to_binary(integer_to_list(P#product.price)++"$")},
      #panel{class=["product-controls", "btn-toolbar"], body=[
        #panel{class=["btn-group"],body=#button{class=["btn btn-warning"], body="Buy It!"}},
        #panel{class=["btn-group"],body=#button{class=["btn btn-info"], body="Review", postback={product, integer_to_list(P#product.id)} }}
      ]} ]} ]}.


pagination(Page)->
  PageCount = (length(wf:session(products)) -1 ) div ?PAGE_SIZE + 1,
  [#li{class=[if Page==1-> "disabled"; true->[] end, "previous"],body=#link{class=["fui-arrow-left"], body= <<"&lsaquo;">>, postback={page, 1}, url="javascript:void(0);" }},
  [#li{class=if I==Page -> active;true->[] end,body=#link{id="pglink"++integer_to_list(I),body=integer_to_list(I), postback={page, I}, url="javascript:void(0);" }} 
    || I <- lists:seq(1, PageCount)],
   #li{class=[if PageCount==Page -> "disabled";true->[] end,"next"], body=#link{class=["fui-arrow-right"], body= <<"&rsaquo;">>, postback={page, PageCount},url="javascript:void(0);" }} ].


carousel()->
  #panel{id=productCarousel, class=[carousel, slide, top, "product-carousel"], data_fields=[{<<"data-interval">>, <<"3000">>}],body=[
    #list{numbered=true, class=["carousel-indicators"], body=[
      #li{data_fields=[{<<"data-target">>, <<"#productCarousel">>}, {<<"data-slide-to">>, <<"0">>}], class=[active]},
      #li{data_fields=[{<<"data-target">>, <<"#productCarousel">>}, {<<"data-slide-to">>, <<"1">>}]},
      #li{data_fields=[{<<"data-target">>, <<"#productCarousel">>}, {<<"data-slide-to">>, <<"2">>}]}
    ]},
    #panel{class=["carousel-inner"], body=[
      #panel{class=[active, item], data_fields=[{<<"data-slide-number">>,<<"0">>}], body=[
        #image{image="/static/img/item-bg.png"},
        #panel{class=["carousel-caption"], body=[
          #h4{body="First image label&copy;"},
          #p{body=[
            "Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
            Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit."]} ]} ]},
      #panel{class=[item], data_fields=[{<<"data-slide-number">>, <<"1">>}], body=[
        #image{image="/static/img/item-bg.png"},
        #panel{class=["carousel-caption"], body=[
          #h4{body="Second image label"},
          #p{body=[
            "Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
            Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit."]} ]} ]},
      #panel{class=[item], data_fields=[{<<"data-slide-number">>, <<"2">>}], body=[
        #image{image="/static/img/item-bg.png"},
        #panel{class=["carousel-caption"], body=[
          #h4{body="Third image label"},
          #p{body=[
            "Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
            Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit."]} ]} ]}
    ]},
    #link{class=["carousel-control", left], url="#productCarousel", data_fields=[{<<"data-slide">>, <<"prev">>}], body="&lsaquo;"},
    #link{class=["carousel-control", right], url="#productCarousel", data_fields=[{<<"data-slide">>, <<"next">>}], body="&rsaquo;"}
  ]}.


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
