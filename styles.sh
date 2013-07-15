#!/bin/sh

APPSTORE=apps/web/priv/static/appstore
CSS=apps/web/priv/static/css

/usr/bin/node apps/web/priv/static/less/bin/lessc -x $APPSTORE/appstore.less > $CSS/appstore.css
