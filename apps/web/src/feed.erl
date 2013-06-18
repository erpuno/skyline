-module(feed).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

-define(PAGE_SIZE, 4).

main() -> #dtl{file="dev", bindings=[{title,<<"feed">>},{body, body()}]}.

body() ->
%  Qid = wf:qs(<<"id">>),
  index:header()++[
  #section{class=[section, alt], body=#panel{class=[container], body=[
    #panel{class=["hero-unit"], body=[
      #h1{body= <<"Product feed">>},
      #p{body= <<"Thats a single review page">>}
    ]}
  ]}},

  #section{class=[section], body=#panel{class=[container], body=#panel{class=["row-fluid"], body=[
    #panel{class=[span9], body=[
      product:blog_post_expanded(),
      #panel{class=[comments], body=[
        #h3{body= <<"comments">>},
        product:comment([product:comment(), product:comment([product:comment()])]),
        product:comment()
      ]},
      #panel{class=["comments-form"], body=[
        #h3{class=["comments-form"], body= <<"Add your comment">>},
        #panel{class=["form-horizontal"], body=[
          #fieldset{body=[
            #panel{class=["control-group"], body=[
              #label{class=["control-label"], for="name", body= <<"Name">>},
              #panel{class=["controls"], body=[
                #textbox{id=name, class=["input-xxlarge"]}
              ]}
            ]},
            #panel{class=["control-group"], body=[
              #label{class=["control-label"], for="email", body= <<"Email">>},
              #panel{class=["controls"], body=[
                #textbox{id=email, class=["input-xxlarge"]}
              ]}
            ]},
            #panel{class=["control-group"], body=[
              #label{class=["control-label"], for="message", body= <<"Your message">>},
              #panel{class=["controls"], body=[
                #textarea{id=message, class=["input-xxlarge"]}
              ]}
            ]},
            #panel{class=["control-group"], body=[
              #panel{class=["controls"], body=[
                #button{class=[btn, "btn-info", "btn-large"], body= <<"send">>}
              ]}
            ]}
          ]}
        ]}
      ]}
    ]},
    #aside{class=[span3, sidebar], body=[
      #panel{class=["sidebar-widget"], body=[
        #h2{class=["sidebar-header"], body= <<"Search">>},
        #panel{class=["input-append"], body=[
          #textbox{id="search-button"},
          #button{class=[btn], body= <<"Go!">>}
        ]}
      ]},
      #panel{class=["sidebar-widget"], body=[
        #h2{class=["sidebar-header"], body= <<"About SmartBiz">>},
        #p{body= <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.">>}
      ]},
      #panel{class=["sidebar-widget"], body=[
        #h2{class=["sidebar-header"], body= <<"Recent posts">>},
        #list{class=[unstyled], body=[
          #li{body=[#h4{body=#link{body = <<"Lorem ipsum dolor sit">>}},
            #p{body=#small{body= <<"November 12, 2012">>}}]},
          #li{body=[#h4{body=#link{body = <<"Ed do eiusmod tempor">>}},
            #p{body=#small{body= <<"August 12, 2012">>}}]},
          #li{body=[#h4{body=#link{body = <<"Incididunt ut labore">>}},
            #p{body=#small{body= <<"June 12, 2012">>}}]},
          #li{body=[#h4{body=#link{body = <<"Quis nostrud exercitation">>}},
            #p{body=#small{body= <<"June 12, 2012">>}}]},
          #li{body=[#h4{body=#link{body = <<"Quis nostrud exercitation">>}},
            #p{body=#small{body= <<"June 12, 2012">>}}]}
        ]}
      ]},
      #panel{class=["sidebar-widget"], body=[
        #h2{class=["sidebar-header"], body= <<"Popular posts">>},
        #list{class=[unstyled], body=[
          #li{body=[#h4{body=#link{body = <<"Lorem ipsum dolor sit">>}},
            #p{body=#small{body= <<"November 12, 2012">>}}]},
          #li{body=[#h4{body=#link{body = <<"Ed do eiusmod tempor">>}},
            #p{body=#small{body= <<"August 12, 2012">>}}]},
          #li{body=[#h4{body=#link{body = <<"Quis nostrud exercitation">>}},
            #p{body=#small{body= <<"June 12, 2012">>}}]}
        ]}
      ]}
    ]}
  ]}}}

  ]++index:footer().

title()-> <<"Review title">>.

description(Id, Description) -> [
  #panel{id="description"++Id, body=[
    #panel{class=[collapse, in], body= <<"Description head">>},
    #panel{id=Id, class=collapse, body= Description}
  ]},
  #button{class=[btn, "btn-link"], data_fields=[
    {<<"data-toggle">>, <<"collapse">>},
    {<<"data-target">>, list_to_binary("#"++Id) },
    {<<"data-parent">>, list_to_binary("#description"++Id)}], body= <<"Read...">>}].

list_medias(C)->
  {Cid, Fid} = C#comment.id,
  [#feed_media{media=M, target=wf:temp_id(), fid = Fid, cid = Cid} ||  M <- C#comment.media].

image_media(_Media)-> element_image:render_element(#image{image= "/static/img/item-bg.png"}).

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).

control_event(Id, Tag) -> 
  error_logger:info_msg("Tinymce editor control event ~p: ~p", [Id, Tag]),
  Ed = wf:q(mcecontent),
  error_logger:info_msg("Data:  ~p", [Ed]),
  ok.