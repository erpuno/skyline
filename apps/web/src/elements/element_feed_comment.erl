-module (element_feed_comment).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

reflect() -> record_info(fields, feed_comment).

render_element(_R = #feed_comment{comment=C}) ->
  #li{body=[
    #panel{body=#link{body= <<"comment">>}},
    #p{body=C#comment.content},
    #panel{class=[media], body=list_medias(C)}
  ]}.

list_medias(C)->
  {Cid, Fid} = C#comment.id,
  [#feed_media{media=M, target=wf:temp_id(), fid = Fid, cid = Cid} ||  M <- C#comment.media].