Skyline: N2O Sample Website
===========================

Skyline was made with Nitrogen DSL and based on [N2O](https://github.com/5HT/n2o).
It is a demo how to use N2O in real-life applications.
Feel free to use it in your projects. It is provided as is in public domain.

![Login](http://synrc.com/lj/N2O+Bootstrap.png)

Prerequisites
=============

* Erlang R16: sudo apt-get install erlang
* Rebar: https://github.com/rebar/rebar
* iNotify Tools (Linux only): sudo apt-get install inotify-tools

Startup
-------------

    make
    make console

Init Database
-------------

In Erlang Shell perform

    > kvs:join().

And open in browser [http://localhost:8001](http://localhost:8001)

Credits
-------

* Maxim Sokhatsky
* Andrew Zadorozhny

OM A HUM
