#!/usr/bin/env bash

NODE=${1:-"web"}
ERLANG_LIB=$(erl -noshell -eval 'io:format("~s", [code:lib_dir()]).' -s erlang halt)

release_node() {
    rm -rf rels/$1/node/lib
    rm -rf rels/$1/node/log
    rm -rf rels/$1/node/releases
    (cd rels/$1; rebar -f generate)
    cp -R $ERLANG_LIB/erl_interface-* rels/$1/node/lib/
    install -d rels/$1/node/kai
}

if [ "$NODE" == "all" ]; then
   echo "Releasing all nodes..."
   release_node web
else
   echo "Releasing node $NODE..."
   release_node $NODE
fi

echo $?
