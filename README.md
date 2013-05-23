Skyline: N2O Promo Example
==========================

This is App Store demo website.
It is made with Nitrogen DSL and based on [N2O](https://github.com/5HT/n2o).
It is a demo how to use N2O in real-life applications.
Feel free to use it in your projects.

CSS
---

    -- Twitter Bootstrap
    -- Flat UI

Credits
-------

    -- Maxim Sokhatsky
    -- Andrew Zadorozhny

Run
---

No fancy scripts, pure rebar and Erlang releases

    $ rebar get-deps
    $ rebar compile
    $ cd rels/web && rebar -f generate
    $ node/bin/node console

And open in browser [http://localhost:8000](http://localhost:8000)

Developers
----------

For developing we use some script which is needed for linking source
directories with release lib directories and also link BERT, N2O and
jQuery javascript. After making release you should perform:

    $ ./nitrogen_static.sh
    $ ./release_sync.sh

OM A HUM
