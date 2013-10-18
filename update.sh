#!/usr/bin/env bash

git pull
rebar clear-deps
rebar get-deps

echo $?