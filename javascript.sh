#!/usr/bin/env bash

uglifyjs=`which uglifyjs`
uglifijs_args='-nc'

check_uglifyjs() {
        if [ "$uglifyjs" == "" ] ; then
                echo "ERROR: uglifyjs not found. Please set uglifyjs in javascript.sh"
                exit 1;
        fi
}

create_script() {
        output="`pwd`/$2"
        echo "Generating `basename $output` in `dirname $output`"
        cp /dev/null $output

        cd $1

        # sort hack to keep order:
        for js in `ls -p -S *.js | egrep -v $3`; do
                echo "-> $js"
                $uglifyjs $uglifyjs_args $js >> $output
        done

        echo "done."
        cd -
}

check_uglifyjs

create_script deps/twitter_btstrp/js apps/web/priv/static/js/bootstrap.min.js "/"
create_script deps/n2o_scripts/n2o   apps/web/priv/static/js/all.min.js "/|all.js|zepto.js|minified.js"

echo $?
