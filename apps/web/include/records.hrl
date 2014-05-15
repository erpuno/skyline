-record(feed_entry,     {?ELEMENT_BASE(product), entry}).
-record(feed_comment,   {?ELEMENT_BASE(product), comment}).
-record(feed_media,     {?ELEMENT_BASE(product), media, target, fid=0, cid=0, only_thumb}).
-record(product_figure, {?ELEMENT_BASE(product), product}).

-record(media, {
        id,
        title :: iolist(),
        width,
        height,
        html :: iolist(),
        url :: iolist(),
        version,
        thumbnail_url :: iolist(),
        type :: {atom(), atom() | string()},
        thumbnail_height}).
