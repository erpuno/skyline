-module (element_feed_entry).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

reflect() -> record_info(fields, feed_entry).

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
  element_li:render_element(Li).

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
