-module(product).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

-define(PAGE_SIZE, 4).

main() -> 
   #dtl{file="prod",  ext="dtl",bindings=[{title,<<"product">>},{body, body()}]}.

body() ->
%  Qid = wf:qs(<<"id">>),
%  Product = case [P || #product{id=Id} = P  <- wf:session(products), Id == list_to_integer(binary_to_list(Qid))] of [] -> []; L -> lists:nth(1,L) end,
  P = product(1,2),

  index:header()++[
  #section{class=[section, alt], body=#panel{class=[container], body=#panel{class=["row-fluid"], body=[
    #panel{class=[span6], body=[
      #panel{class=["hero-unit"], body=[
        #h1{body=P#product.title},
        #p{body=P#product.brief},
        #button{class=[btn, "btn-large", "btn-info"], body= <<"buy it">>, postback={product, integer_to_list(P#product.id)}}
      ]}
    ]},
    #panel{class=[span6], body=#image{image=P#product.cover}}
  ]}}},

  #section{class=[section], body=#panel{class=[container], body=#panel{class=["row-fluid"], body=[
    #panel{class=[span9], body=[
      [blog_post() || _I <- lists:seq(1,3)],
      #list{class=[pager], body=[
        #li{class=[previous], body=#link{body=[#i{class=["icon-chevron-left"]}, <<" Older">> ]}},
        #li{class=[next], body=#link{body=[#i{class=["icon-chevron-right"]}, <<" Newer">> ]}}
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

%  #panel{class=["container"], body=[
%    #panel{class=["row-fluid"], body=[
%      #panel{class=[span4, "product-view"], body=#product_figure{product=P}},
%      #panel{class=[span8], body=#list{class=[thumbnails], body=feed()} }
%    ]}
%  ]}
  ]++index:footer().

blog_post()-> % feed entry
  #article{class=["blog-post"], body=[
    #header{class=["blog-header"], body=[
          #h2{body=[<<"Lorem ipsum dolor">>, #small{body=[<<" by">>, #link{body= <<" John Doe">>}, <<" 12 Sep 2012.">>]}]}
    ]},
    #figure{class=["thumbnail-figure"], body=[
          #link{url= <<"/feed?id=1">>, body=[#image{image= <<"/static/img/crysis3-bg1.png">>} ]},
          #figcaption{class=["thumbnail-title"], body=[
            #h3{body=#span{body= <<"Lorem ipsum dolor sit amet">>}}
          ]}
    ]},
    #p{body= <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,            quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo            consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.">>},
    #footer{class=["blog-footer", "row-fluid"], body=[
          #panel{class=[span4, "blog-categories"], body=[#i{class=["icon-pushpin"]}, #link{body= <<" consectetur">>}]},
          #panel{class=[span4, "blog-tags"], body=[#i{class=["icon-tags"]}, #link{body= <<" fugiat, nulla, pariatur">>}]},
          #panel{class=[span4, "blog-more"], body=[#i{class=["icon-link"]}, #link{body= <<" read more">>}]}
    ]}
  ]}.

blog_post_expanded()->
  #article{class=["blog-post"], body=[
    #header{class=["blog-header"], body=[
      #h2{body=[<<"Lorem ipsum dolor">>, #small{body=[<<" by">>, #link{body= <<" John Doe">>}, <<" 12 Sep 2012.">>]}]}
    ]},
    #figure{class=["thumbnail-figure"], body=[
          #link{url= <<"/feed?id=1">>, body=[#image{image= <<"/static/img/crysis3-bg1.png">>} ]},
          #figcaption{class=["thumbnail-title"], body=[
            #h3{body=#span{body= <<"Lorem ipsum dolor sit amet">>}}
          ]}
    ]},
    #p{body= <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,            quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo            consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.">>},
    #p{body= <<"Nullam eget suscipit turpis. Suspendisse nec magna et velit elementum vulputate. Suspendisse ac nibh lectus, at sollicitudin turpis. Aenean ut tortor a felis consectetur pulvinar. Phasellus mattis viverra luctus. Pellentesque tempor bibendum arcu non vestibulum. In bibendum mattis nibh, nec laoreet enim pretium a. Donec augue sem, convallis euismod pellentesque non, facilisis non nulla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis blandit cursus mi, malesuada euismod enim accumsan nec. Pellentesque nisl enim, elementum non molestie eu, lobortis sed odio. Mauris vehicula commodo neque, nec viverra libero accumsan in.">>},
    #panel{class=["row-fluid"], body=[
      #panel{class=[span6], body=#p{body= <<"Vestibulum et dapibus orci. Vivamus non elit sed quam egestas egestas. Donec interdum ultrices ante ac pharetra. Praesent euismod augue erat, vel ornare sem. Morbi ante nisl, fringilla at commodo vitae, cursus aliquet lacus. Maecenas nec orci at est venenatis congue vitae eget justo. Aenean dui odio, eleifend sed viverra et, eleifend vitae tortor. Duis ac diam vitae risus aliquam tempor. Phasellus volutpat, metus porttitor ornare gravida, erat lacus bibendum lectus, et dictum tortor ligula a est. Proin id purus eget mi vestibulum accumsan. Nam scelerisque malesuada tellus vel laoreet. Vestibulum eleifend, risus ut faucibus iaculis">>}},
      #panel{class=[span6], body=[#image{image= <<"/static/img/crysis3-bg2.png">>}]}
    ]},
    #p{body= <<"Quisque diam libero, aliquam eget blandit et, vulputate vel felis. Quisque ut purus at justo mattis volutpat. Curabitur nibh neque, sodales feugiat suscipit vel, vulputate nec quam. Sed quam nulla, sollicitudin non pulvinar in, viverra ac nunc. Maecenas a neque quis mauris vehicula viverra eu eget elit. Suspendisse potenti. Donec tincidunt sollicitudin elementum. Nunc volutpat purus ac lectus tincidunt et bibendum quam sollicitudin. Pellentesque rutrum ultricies porttitor. Suspendisse pellentesque rutrum mollis. Integer varius nulla quis metus varius imperdiet. ">>},
    #footer{class=["blog-footer", "row-fluid"], body=[
          #panel{class=[span4, "blog-categories"], body=[#i{class=["icon-pushpin"]}, #link{body= <<" consectetur">>}]},
          #panel{class=[span4, "blog-tags"], body=[#i{class=["icon-tags"]}, #link{body= <<" fugiat, nulla, pariatur">>}]},
          #panel{class=[span4, "blog-more"], body=[#i{class=["icon-link"]}, #link{body= <<" read more">>}]}
    ]}
  ]}.

comment() -> comment([]).
comment(InnerComment)->
  #panel{class=[media, "media-comment"], body=[
    #link{class=["pull-left"], body=[
      #image{class=["media-objects","img-circle"], data_fields=[{<<"data-src">>, <<"holder.js/64x64">>}]}
    ]},
    #panel{class=["media-body"], body=[
      #p{class=["media-heading"], body=[
        <<"John Doe, 12 Sep 2012.">>, 
        #link{class=["comment-reply","pull-right"], body= <<"reply">>}
      ]},
      #p{body= <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.">>},
      InnerComment
    ]}
  ]}.

feed() -> [#feed_entry{entry=E} || E <- entries(), _I <- lists:seq(1, 5)].

render_element(#product_figure{product=P})-> 
  {PriceHead, PriceClass, BtnClass} = case P#product.price of % case for featured product
      true  ->  {<<"Featured">>, ["pricing-table-featured", "product-price-featured"], []};
      false  -> {<<"Featured">>, ["pricing-table-featured", "product-price-featured", "featured-orange"], []};
      _ ->      {<<"Standard">>, [], ["btn-info"]}
  end,

  L = #link{url= list_to_binary("/product?id="++ integer_to_list(P#product.id)), body=#figure{class=[product, "thumbnail-figure"], body=[
    #image{image=P#product.cover},
    #figcaption{class=["row-fluid", "product-caption"], body=[
      #panel{class=["product-title", "thumbnail-title" ], body=[
        #h3{body=#span{body=P#product.title}},
        #p{body=#span{body=P#product.brief}},
        #span{class=[badges],body=[
          #i{class=["icon-user"]}, #span{class=["badge badge-info"], body= <<"1024">>},
          #i{class=["icon-comment"]}, #span{class=["badge badge-info"], body= <<"10">>}
        ]} ]},
      #panel{class=["well","pricing-table", "product-price", span3, "text-center"]++PriceClass, body=[
        #h3{body=#span{body=PriceHead}},
        #h2{class=["pricing-table-price", "product-price-price"], body=[#span{body= <<"$">>}, list_to_binary(io_lib:format("~.2f", [P#product.price]))]},

        #list{class=["pricing-table-list", "product-price-list"], body=[
          #li{body= <<"Lorem ipsum">>},
          #li{body= <<"dolor sit amet">>}
        ]},
        #button{class=[btn, "btn-large"]++BtnClass, body= <<"buy it">>, postback={product, integer_to_list(P#product.id)}}
      ]} 
]} ]} },
  element_link:render_element(L);

render_element(#feed_entry{entry=E, id=Id}) ->
  {{Y, Mm, D}, {_H, _M, _S}} = E#entry.created,

  Li = #li{class=[thumbnail, span12, clearfix, "product-review"], body=[
    #panel{class=[span3, "review-author"], body=[
      #link{class=[avatar], body=#image{class=["img-circle"], data_fields=[{<<"data-src">>, <<"holder.js/100x100">>}]}},
      #p{body=[
        #link{url="#", body=[ #i{class=["icon-user"]}, #span{body =E#entry.from}]},
        #span{class=["review-date"],body=[#i{class=["icon-calendar"]}, io_lib:format("~p/~p/~p",[Mm, D, Y]) ]},
        #link{url="#",body=[ #i{class=["icon-thumbs-up"]}, #span{class=["badge badge-info"], body= <<"3">>} ]},
        #link{url="#",body=[ #i{class=["icon-comment"]}, #span{class=["badge badge-info"], body= <<"10">>} ]},
        #link{url="#",body=[ #i{class=["icon-share"]}, #span{class=["badge badge-info"], body= <<"5">>} ]}
      ]}
    ]},

    #panel{class=[span3], body=[#feed_media{media=M} || M <- E#entry.media]},

    #panel{class=[span6], body=[
      #h4{body = title()},
      description(wf:temp_id(), E#entry.description)
    ]},

    #list{class=[comments],body=list_comments(Id)}
  ]},
  element_li:render_element(Li);
render_element(_R = #feed_comment{comment=C}) ->
  #li{body=[
    #panel{body=#link{body= <<"comment">>}},
    #p{body=C#comment.content},
    #panel{class=[media], body=list_medias(C)}
  ]};
render_element(FeedMedia = #feed_media{media = Media}) ->
  case Media#media.type of
    image -> image_media(FeedMedia);
    _ -> image_media(FeedMedia)
  end.

list_comments(_Eid)->
  Comments =[],
  [#feed_comment{comment=C}|| C <- Comments].

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
event({counter,C}) -> wf:update(onlinenumber,wf:to_list(C));
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).

control_event(Id, Tag) -> 
  error_logger:info_msg("Tinymce editor control event ~p: ~p", [Id, Tag]),
  Ed = wf:q(mcecontent),
  error_logger:info_msg("Data:  ~p", [Ed]),
  ok.

entries()-> [
  #entry{
    id={1,1},
    description= <<"The award-winning developer Crytek is back with Crysis 3, the first blockbuster shooter of 2013!">>,
    from= <<"Pupkin">>,
    created = calendar:local_time(),
    type= {product, normal},
    media= [
      #media{
        id=1,
        type = image,
        title= <<"Media1">>,
        html= <<"<b>Media1</b>">>,
        url = <<"/static/img/p1.jpg">>,
        thumbnail_url = <<"/static/img/p1.jpg">> }] }].

product() -> product(1,1).
product(Id, Pic)->
    #product{
      id=Id,
      title = <<"Crysis 3">>,
      categories= [1],
      brief= <<"<h2>Crytek is back with Crysis 3</h2> The award-winning developer Crytek is back with Crysis 3, the first blockbuster shooter of 2013!Return to the fight as Prophet, the Nanosuit soldier on a quest to rediscover his humanity. Adapt on the fly with the stealth and armor abilities of your unique Nanosuit as you battle through the seven wonders of New York’s Liberty Dome. Unleash the firepower of your all-new, Predator bow and alien weaponry to hunt both human and alien enemies. Crysis 3 is the ultimate sandbox shooter, realized in the stunning visuals only Crytek and the latest version of CryENGINE can deliver. Available now on Xbox 360, PlayStation 3, and PC">>,
      cover = "/static/img/crysis3-bg" ++ integer_to_list(Pic)++".png",
      publish_start_date = calendar:local_time(),
      publish_end_date =  calendar:local_time(),
      price=22.95}.
