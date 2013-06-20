#!/bin/bash

FILES=apps/web/priv/static/nitrogen
BOOTSTRAP=apps/web/priv/static/bootstrap
LESS=apps/web/priv/static/less
rm -rf $FILES
rm -rf $BOOTSTRAP
rm -rf $LESS
rm -rf $FLATUI
ln -s ../../../../deps/n2o/priv/static/n2o $FILES
ln -s ../../../../deps/bootstrap $BOOTSTRAP
ln -s ../../../../deps/less.js $LESS
