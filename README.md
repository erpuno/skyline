Skyline: N2O Promo Example
==========================

This is App Store demo website.
It is made with Nitrogen DSL and based on [N2O](https://github.com/5HT/n2o).
It is a demo how to use N2O in real-life applications.
Feel free to use it in your projects.

![Login](http://synrc.com/lj/N2O+Bootstrap.png)

Prerequisites
=============

* Erlang R16: sudo apt-get install erlang
* Rebar: https://github.com/rebar/rebar
* iNotify Tools: sudo apt-get install inotify-tools

Optional Prerequisites
======================

For developing rich applications usually you need to plug
JavaScript controls and write custom CSS using LESS.
For that purposes Skyline introduces you an modern asset arhitecture
based on node tools.

JavaScript Prerequisites
-----------------------

    $ sudo apt-get install python-software-properties
    $ sudo add-apt-repository ppa:richarvey/nodejs
    $ sudo apt-get update
    $ sudo apt-get install nodejs
    $ sudo apt-get install npm
    $ sudo npm install uglify-js -g

If you want just try Skyline you don't need to install node tools.
You need it only when you developing you own CSS/JavaScript derivatives.

Install Scenarios
=================

UNIX/LXC
--------

Use this scenation on your server/desktop/notebook.

    $ make
    $ make start
    $ make attach
    > application:which_applications().
    
Xen
---

Use this scenario to try Xen deployment.

    $ sudo apt-get install xen-hypervisor-amd64
    $ echo XENTOOLSTACK=xl > /etc/default/xen
    $ sudo brctl addbr docker0
    $ sudo ip addr add 172.16.42.1/24 dev docker0

    $ make
    $ rebar ling-build-image

    $ truncate -s 100m disk
    $ sudo xl create -c xen.config
    > application:start(web).


Init DB (Mnesia)
----------------

    > kvs:join().
    > kvs:init_db().
    > kvs:dir().
    > kva:all(user).
    
And open in browser
-------------------

* LXC: [http://localhost:8000](http://localhost:8000)
* Xen: [http://172.16.42.108:8000](http://172.16.42.108:8000)

Credits
-------

* Maxim Sokhatsky
* Andrew Zadorozhny

OM A HUM
