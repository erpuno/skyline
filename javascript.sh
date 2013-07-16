#!/bin/bash

# npm install uglify-js -g

function create_script {
  cd $1
  args=()
  for i in `ls -p -S *.js | egrep -v $3`; do #sort hack to keep order
    echo $i
    args+=($(uglifyjs $i))
  done
  cd -
  echo $2
  echo ${args[@]} > $2
}

create_script deps/n2o/priv/static/bootstrap/js apps/web/priv/static/js/bootstrap.min.js "/"
create_script deps/n2o/priv/static/n2o apps/web/priv/static/js/all.min.js "/|all.js|zepto.js"
