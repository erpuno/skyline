-module(grid).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include_lib("kvs/include/products.hrl").

-define(PAGE_SIZE, 2).

main() -> [#dtl{file="dev", bindings=[{title,<<"Grid2.psd">>},{body, body()}]}].

body() ->
  products:fill_prods(),
  index:header() ++ [
    #panel{class=["container"],body=[
      #panel{class=["row-fluid"], body=[ #panel{id=products, body=product_list(1)}, tags() ]},
      #button{class=["btn"], data_fields=[{<<"data-toggle">>,<<"modal">>}, {<<"data-target">>, <<"#addProduct">>}], body= <<"Add product">>},
      add_product()
    ]}
  ] ++ index:footer().

product_list(Page) ->
  Prods = wf:session(products),
  PageCount = (length(Prods) -1 ) div ?PAGE_SIZE + 1,
  error_logger:info_msg("PageCount ~p length: ~p~n", [PageCount, length(Prods)]),

  #panel{class=span9, body=[
    #list{class=[thumbnails], body=[
      begin
        Id = wf:temp_id(),
        #li{class=["thumbnail", "span12", "clearfix"], style="margin-left:0;", body=[
          #panel{class=span3, body=[
            #h4{body = P#product.name},
            #p{body=[#span{style="display:block;", body = <<"John Smith">>},#small{body= <<"Yesterday, 1:00 pm">>}]},
            #link{url="#",body=[ #i{class=["icon-user"]}, #span{class=["badge badge-info"], body= <<"1024">>} ]},
            #link{url="#",body=[ #i{class=["icon-comment"]}, #span{class=["badge badge-info"], body= <<"10">>} ]} ]},
          #link{class=span4, body=#image{class=["img-polaroid"], image=P#product.image_small_url}},
          #panel{class=span5, body=[
            #h4{body = <<"Description head">>},
            #p{id=Id, class=["collapse", "in"], body=P#product.description_short},
            #button{class=[btn, "btn-link"], data_fields=[{<<"data-toggle">>, <<"collapse">>}, {<<"data-target">>, list_to_binary("#"++Id) }], body= <<"Read...">>}
          ]} ]}
      end || P <- lists:sublist(Prods, (Page-1) * ?PAGE_SIZE + 1, ?PAGE_SIZE)]},

    #panel{class=["pagination pagination-large pagination-centered"],body=[
      #list{body=[
         #li{class=if Page==1 -> [disabled, previous];true->[previous] end,body=#link{class=["fui-arrow-left"], body= <<"&lsaquo;">>, postback={page, 1}, url="javascript:void(0);"}},
        [#li{class=if Page==I -> [active];    true->[] end,body=#link{id="pagelink"++integer_to_list(I),body=integer_to_list(I), postback={page, I}, url="javascript:void(0);" }} || I <- lists:seq(1, PageCount)],
         #li{class=if Page==PageCount -> [disabled, next];true->[next] end, body=#link{class=["fui-arrow-right"], body= <<"&rsaquo;">>, postback={page, PageCount}}}
      ]} ]} ]}.

tags()->
    #panel{class=[span3], body=[
      #h2{body = <<"Tags">>},
      #list{class=["inline"],body=[
        #li{body=#link{url= <<"#">>, body= <<"Pellentesque">>}},
        #li{body=#link{url= <<"#">>, body= <<"habitant">>}},
        #li{body=#link{url= <<"#">>, body=#small{body= <<"senectus">>}}},
        #li{body=#link{url= <<"#">>, body=#strong{body= <<"et">>}}},
        #li{body=#link{url= <<"#">>, body= <<"malesuada">>}, class=["tag-small"]},
        #li{body=#link{url= <<"#">>, body= <<"Vivamus">>}, class=["tag-large"]},
        #li{body=#link{url= <<"#">>, body= <<"mi">>}, class=["tag-mini"]},
        #li{body=#link{url= <<"#">>, body=#strong{body= <<"est">>}}},
        #li{body=#link{url= <<"#">>, body=#small{body= <<"molestie">>}}},
        #li{body=#link{url= <<"#">>, body= <<"rutrum">>}, class=["tag-large"]},
        #li{body=#link{url= <<"#">>, body= <<"quis">>}},
        #li{body=#link{url= <<"#">>, body=#small{body= <<"scelerisque">>}}},
        #li{body=#link{url= <<"#">>, body= <<"netus">>}},
        #li{body=#link{url= <<"#">>, body= <<"fames">>}, class=["tag-huge"]},
        #li{body=#link{url= <<"#">>, body=#strong{body= <<"ac">>}}},
        #li{body=#link{url= <<"#">>, body= <<"morbi">>}}
      ]}
    ]}.

add_product()->
  #panel{id=addProduct, class=[modal, hide], tabindex="-1", role="dialog", 
         aria_states=[{<<"aria-labeled-by">>, <<"addProductLabel">>}, {<<"aria-hidden">>,<<"true">>}], body=[
    #panel{class=["modal-header"], body=[
      #button{class=["close"], data_fields=[ {<<"data-dismiss">>, <<"modal">>}], aria_states=[{<<"aria-hidden">>, <<"true">>}], body= <<"&times;">>},
      #h3{id=myModalLabel, body= <<"Add product">>}
    ]},
    #panel{class=["modal-body", "form-horizontal"], body=[
      #panel{class=["control-group"], body=[
        #label{class=["control-label"], for=prodName, body= <<"Name">>},
        #panel{class=[controls], body=[
          #textbox{id=prodName, placeholder= <<"Name">>}
        ]}]},
      #panel{class=["control-group"], body=[
        #label{class=["control-label"], for=prodDescription, body= <<"Description">>},
        #panel{class=[controls], body=[
          #textarea{id=prodDescription, placeholder= <<"type description here...">>}
        ]}]},
      #panel{class=["control-group"], body=[
        #label{class=["control-label"], for=prodImage, body= <<"Image URL">>},
        #panel{class=[controls], body=[
          #textbox{id=prodImage, placeholder= <<"image URL">>}
        ]}]}
    ]},
    #panel{class=["modal-footer"], body=[
      #button{ class=["btn"], data_fields=[{<<"data-dismiss">>, <<"modal">>}], aria_states=[{<<"aria-hidden">>, <<"true">>}], body= <<"Close">>},
      #button{id=saveProd, class=["btn","btn-primary"], body= <<"Save">>,
              data_fields=[{<<"data-dismiss">>, <<"modal">>}], postback=add_product, source=[prodName, prodDescription, prodImage]}
    ]}
  ]}.

test()->
    #panel{class=[span9, "row-fluid"],body=[
      #list{class=["nav nav-tabs"], body=[
        #li{class=["active"], body=#link{url= <<"#users">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Users">> }},
        #li{body=#link{url= <<"#system">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"System">> }},
        #li{body=#link{url= <<"#statistic">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Statistics">> }},
        #li{body=#link{url= <<"#reports">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Reports">> }}
      ]},
      #panel{class=["tab-content"], body=[
        #rtable{id=users, class=["tab-pane", "active"], rows=qlc:next_answers(qlc:cursor(ets:table(cookies, [{traverse, first_next}])), 1) },
        #panel{id=system, class=["tab-pane"], body=[]},
        #panel{id=statistic, class=["tab-pane"], body=[]},
        #panel{id=reports, class=["tab-pane"], body=[]}
      ]}
    ]}.


event(init) -> [];
event({page, Page})-> error_logger:info_msg("grid paging"),wf:update(products, product_list(Page));
event(add_product)->
  NewProd = #product{id=kvs:next_id(product), name=wf:q(prodName), description_short=wf:q(prodDescription), image_small_url=wf:q(prodImage)},
  error_logger:info_msg("Add product Review~p", [NewProd]),
  kvs:put(NewProd),
  wf:session(products, kvs:all(product)),
  wf:update(products, product_list(1));
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

control_event(Id, Tid) ->
  error_logger:info_msg("Control event on ~p ~p", [Id, Tid]),
  error_logger:info_msg("Page ~p", [wf:q(page)]),
  Page = list_to_integer(wf:q(page)),
  error_logger:info_msg("Page: ~p", [Page]),
  wf:update(Tid, element_rtable:render_table(Tid, [lists:nth(Page, qlc:next_answers(qlc:cursor(ets:table(cookies, [{traverse, first_next}])), Page))] )).
