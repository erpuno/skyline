-module(grid).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

main() -> [#dtl{file="dev", bindings=[{title,<<"Grid2.psd">>},{body, wf:render(body())}]}].

body() ->
  store2:header() ++ [
  #panel{class=["container"],body=[
  #panel{id=myCarousel, class=["carousel", "slide", "top"], data_fields=[{<<"data-interval">>, <<"5000">>}],body=[
    #list{numbered=true, class=["carousel-indicators"], body=[
      #li{data_fields=[{<<"data-target">>, <<"#myCarousel">>}, {<<"data-slide-to">>, <<"0">>}], class=[active]},
      #li{data_fields=[{<<"data-target">>, <<"#myCarousel">>}, {<<"data-slide-to">>, <<"1">>}]},
      #li{data_fields=[{<<"data-target">>, <<"#myCarousel">>}, {<<"data-slide-to">>, <<"2">>}]}
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
    #link{class=["carousel-control", left], url="#myCarousel", data_fields=[{<<"data-slide">>, <<"prev">>}], body="&lsaquo;"},
    #link{class=["carousel-control", right], url="#myCarousel", data_fields=[{<<"data-slide">>, <<"next">>}], body="&rsaquo;"}
  ]},

  #panel{class=["row-fluid"], body=[
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
    ]},
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
    ]}
  ]}

  ]}
].

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

control_event(Id, Tid) ->
  error_logger:info_msg("Control event on ~p ~p", [Id, Tid]),
  error_logger:info_msg("Page ~p", [wf:q(page)]),
  Page = list_to_integer(wf:q(page)),
  error_logger:info_msg("Page: ~p", [Page]),
  wf:update(Tid, element_rtable:render_table(Tid, [lists:nth(Page, qlc:next_answers(qlc:cursor(ets:table(cookies, [{traverse, first_next}])), Page))] )).
