-module(grid).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [#dtl{file="prod", bindings=[{title,<<"Grid2.psd">>},{body, wf:render(body())}]}].

body() -> store2:header() ++ [
  #panel{class=[container],body=[
  #panel{id=myCarousel, class=["carousel", "slide"], data_fields=[{<<"data-interval">>, <<"5000">>}],body=[
    #list{numbered=true, class=["carousel-indicators"], body=[
      #li{data_fields=[{<<"data-target">>, <<"#myCarousel">>}, {<<"data-slide-to">>, <<"0">>}], class=[active]},
      #li{data_fields=[{<<"data-target">>, <<"#myCarousel">>}, {<<"data-slide-to">>, <<"1">>}]},
      #li{data_fields=[{<<"data-target">>, <<"#myCarousel">>}, {<<"data-slide-to">>, <<"2">>}]}
    ]},
    #panel{class=["carousel-inner"], body=[
      #panel{class=[active, item], data_fields=[{<<"data-slide-number">>,<<"0">>}], body=[
        #image{image="/static/img/bootstrap-mdo-sfmoma-01.jpg"},
        #panel{class=["carousel-caption"], body=[
          #h4{text="First image label"},
          #p{body=[
            "Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
            Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit."]} ]} ]},
      #panel{class=[item], data_fields=[{<<"data-slide-number">>, <<"1">>}], body=[
        #image{image="/static/img/bootstrap-mdo-sfmoma-02.jpg"},
        #panel{class=["carousel-caption"], body=[
          #h4{text="Second image label"},
          #p{body=[
            "Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
            Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit."]} ]} ]},
      #panel{class=[item], data_fields=[{<<"data-slide-number">>, <<"2">>}], body=[
        #image{image="/static/img/bootstrap-mdo-sfmoma-01.jpg"},
        #panel{class=["carousel-caption"], body=[
          #h4{text="Third image label"},
          #p{body=[
            "Cras justo odio, dapibus ac facilisis in, egestas eget quam. 
            Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit."]} ]} ]}
    ]},
    #link{class=["carousel-control", left], url="#myCarousel", data_fields=[{<<"data-slide">>, <<"prev">>}], text="&lsaquo;"},
    #link{class=["carousel-control", right], url="#myCarousel", data_fields=[{<<"data-slide">>, <<"next">>}], text="&rsaquo;"}
  ]}
  ]}
].

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].