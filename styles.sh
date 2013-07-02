#!/bin/sh

APPSTORE=apps/web/priv/static/appstore
CSS=apps/web/priv/static/css

/usr/bin/node deps/less.js/bin/lessc -x $APPSTORE/appstore.less > $CSS/appstore.css

