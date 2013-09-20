#!/bin/sh

APPSTORE=apps/web/priv/static/appstore
CSS=apps/web/priv/static/css

NODE_APP=/usr/bin/node

$NODE_APP apps/web/priv/static/less/bin/lessc -x $APPSTORE/appstore.less > $CSS/appstore.css
