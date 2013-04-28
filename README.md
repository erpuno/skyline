Synrc Web Framework for Erlang
==============================

Nitrogen 2 Optimized
--------------------

* Page construction from binaries
* Do all Actions through WebSocket channel
* Work within Cowboy processes
* Bert/jQuery only w/o JSON, urlencode, pickling and nitrogen.js
* Compatible enough to transfer Nitrogen sites
* Clean codebase
* Separate Advanced Nitrogen elements

Credits
-------

    -- Maxim Sohatsky
    -- Andrew Zadorozhny

Run
---

No fancy scrcipts, pure rebar and Erlang releases

    $ rebar get-deps
    $ rebar compile
    $ cd rels/web && rebar -f generate
    $ node/bin/node console

And open in browser http://localhost:8000
NOTE: All bundled *.sh script only for N2O developers.
