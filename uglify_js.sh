#!/bin/bash

# npm install uglify-js -g

function create_script {
  cd $1
  args=()
  for i in `ls -p -S | grep -v "/"`; do #sort hack to keep order
    echo $i
    args+=($(uglifyjs $i))
  done
  echo ${args[@]} > $2
  cd -
}

create_script deps/bootstrap/js ../../../apps/web/priv/static/js/bootstrap.min.js
create_script deps/flat-ui/js ../../../apps/web/priv/static/js/flat-ui.min.js




