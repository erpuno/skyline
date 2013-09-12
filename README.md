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
* Skyline (LESS)

JavaScript
----------

* Node <=0.8
* Uglify.js tool
* Less.js tool
* BERT.js
* Bullet.js

JavaScript Prerequisites
-----------------------

    $ sudo apt-get install python-software-properties
    $ sudo add-apt-repository ppa:chris-lea/node.js
    $ sudo apt-get update
    $ sudo apt-get install nodejs=0.10.18-1chl1~precise1 npm
    $ sudo npm install uglify-js -g

Unix
----

    $ rebar get-deps
    $ rebar compile
    $ ./nitrogen_static.sh
    $ ./release.sh
    $ ./release_sync.sh
    $ ./styles.sh
    $ ./javascript.sh
    $ ./start.sh

    $ ./attach.sh
    > application:which_applications().
    
Xen
---

    $ sudo apt-get install xen-hypervisor-amd64
    $ echo XENTOOLSTACK=xl > /etc/default/xen
    $ sudo brctl addbr docker0
    $ sudo ip addr add 172.16.42.1/24 dev docker0

    $ rebar get-deps
    $ rebar compile
    $ ./nitrogen_static.sh
    $ rebar ling-build-image

    $ truncate -s 100m disk
    $ sudo xl create -c domain_config
    > application:start(web).


Init DB (Mnesia)
----------------

    > store_mnesia:single().
    > kvs:init_db().
    > kvs:dir().
    > kva:all(user).
    
And open in browser
-------------------

* Unix: [http://localhost:8000](http://localhost:8000)
* Xen: [http://172.16.42.108:8000](http://172.16.42.108:8000)

Credits
-------

* Maxim Sokhatsky
* Andrew Zadorozhny

OM A HUM
