#!/usr/bin/env bash

git pull
rebar delete-deps
rebar get-deps

echo $?