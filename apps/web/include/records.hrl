-record(feed_entry,     {?ELEMENT_BASE(element_feed_entry), entry}).
-record(feed_comment,   {?ELEMENT_BASE(element_feed_comment), comment}).
-record(feed_media,     {?ELEMENT_BASE(element_feed_media), media, target, fid=0, cid=0, only_thumb}).

