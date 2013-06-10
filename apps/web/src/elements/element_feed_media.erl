-module (element_feed_media).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

reflect() -> record_info(fields, feed_media).

render_element(FeedMedia = #feed_media{media = Media}) ->
  case Media#media.type of
    image -> image_media(FeedMedia);
    _ -> image_media(FeedMedia)
  end.

image_media(Media)-> element_image:render_element(#image{image= "/static/img/item-bg.png"}).
