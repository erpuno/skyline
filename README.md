Skyline: N2O Promo Example
==========================

This is App Store demo website.
It is made with Nitrogen DSL and based on [N2O](https://github.com/5HT/n2o).
It is a demo how to use N2O in real-life applications.
Feel free to use it in your projects.

![Login](http://synrc.com/lj/N2O+Bootstrap.png)

CSS
---

* Twitter Bootstrap (LESS)
* Flat UI (Compiled from SASS)
* Skyline (LESS)

JavaScript
----------

* Node 0.8 minimal
* Uglify.js tool
* Less.js tool
* BERT.js
* Bullet.js

Run
---

No fancy scripts, pure rebar and Erlang releases

    $ rebar get-deps
    $ rebar compile
    $ ./release.sh
    $ ./styles.sh
    $ ./javascript.sh
    $ ./start.sh

And open in browser [http://localhost:8000](http://localhost:8000)

Credits
-------

* Maxim Sokhatsky
* Andrew Zadorozhny

OM A HUM
