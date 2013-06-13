-module(product).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

-define(PAGE_SIZE, 4).

-record(feed_entry,     {?ELEMENT_BASE(product), entry}).
-record(feed_comment,   {?ELEMENT_BASE(product), comment}).
-record(feed_media,     {?ELEMENT_BASE(product), media, target, fid=0, cid=0, only_thumb}).


main() -> #dtl{file="dev", bindings=[{title,<<"product">>},{body, body()}]}.

body() ->
%  Qid = wf:qs(<<"id">>),
%  Product = case [P || #product{id=Id} = P  <- wf:session(products), Id == list_to_integer(binary_to_list(Qid))] of [] -> []; L -> lists:nth(1,L) end,
  Product = product(),

  index:header()++[
  #panel{class=["container"], body=[
    #panel{class=["row-fluid"], body=[
      #panel{class=[span4, "product-view"], body=product(Product)},
      #panel{class=[span8], body=#list{class=[thumbnails], body=feed()} }
    ]}
  ]}
  ]++index:footer().

product(P = #product{})->
  #panel{class=[product, "row-fluid"], body=[
    #link{class=[span4,"product-image"], body=#image{image=P#product.image_small_url}, postback={product, integer_to_list(P#product.id)} },
    #panel{class=[span2, "product-name"], body=[
      #h4{body = P#product.name},
      #panel{class=[badges],body=[
        #link{url="#",body=[ #i{class=["icon-user"]}, #span{class=["badge badge-info"], body= <<"1024">>} ]},
        #link{url="#",body=[ #i{class=["icon-comment"]}, #span{class=["badge badge-info"], body= <<"10">>} ]} ]} ]},
    #panel{class=[span3, "product-description"], body=[
      #h4{body = P#product.description_short},
      #p{body=P#product.description_long} ]},
    #panel{class=[span3, "product-price"], body=[
      #h2{body=list_to_binary(integer_to_list(P#product.price)++"$")},
      #panel{class=["product-controls", "btn-toolbar"], body=[
        #panel{class=["btn-group"],body=#button{class=["btn btn-warning"], body="Buy It!"}},
        #panel{class=["btn-group"],body=#button{class=["btn btn-info"], body="Review", postback={product, integer_to_list(P#product.id)} }}
      ]} ]} ]}.


feed() -> [#feed_entry{entry=E} || E <- entries(), _I <- lists:seq(1, 5)].

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

product()->
    #product{
      id=1,
      name = list_to_binary("Name " ++ integer_to_list(1)),
      categories= [1],
      description_short= <<"Description header ">>,
      description_long= <<"Very long description Very long description Very long description">>,
      image_small_url = "/static/img/item-bg.png",
      image_big_url="/static/img/item-bg.png",
      publish_start_date = calendar:local_time(),
      publish_end_date =  calendar:local_time(),
      price=1000,
      our_price=999,
      creation_date= calendar:local_time()}.
