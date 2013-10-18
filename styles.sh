#!/usr/bin/env bash

APPSTORE=apps/web/priv/static/appstore
CSS=apps/web/priv/static/css

NODE_APP=node

$NODE_APP apps/web/priv/static/less/bin/lessc -x $APPSTORE/appstore.less > $CSS/appstore.css

echo $?
