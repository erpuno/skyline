Skyline: N2O Based Example Web Application
==========================================

This Nitrogen Site is based on N2O
----------------------------------

Credits
-------

    -- Maxim Sohatsky
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
