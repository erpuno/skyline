-module(chat).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "tblist", bindings=[{title,<<"Login">>},{body,wf:render(body())}]} ].

body() -> store2:header() ++ [

    #panel{class=span3,body=[
        #panel{class=[container,thumbnail],style="background-color: #f5f5f5; margin-top: 100px;",body=[
            #panel{class=row,body=[
                #panel{class=["media"],style="",body=[
                    #panel{class=["media-body"],body=[#b{text="doxtop"}]}
                ]},
                #panel{class=["media"],style="",body=[
                    #panel{class=["media-body"],body=[#b{text="maxim"}]}
                ]}
            ]}
        ]}
    ]},

    #panel{class=span3,body=[
        #panel{class=[container,thumbnail],style="background-color: #f5f5f5; margin-top: 100px;",body=[
            #panel{class=row,body=[
                #panel{class=["media"],style="",body=[
                    #link{class=["pull-left"],
                        body=[
                           #image{class=["media-object"],image="static/flatui/images/illustrations/infinity.png",width= <<"64">>}
                        ]
                    },
                    #panel{class=["media-body"],body=[
                        #h4{text="doxtop"},
                        #span{text="Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus."}
                    ]}
                ]},
                #panel{class=["media"],style="",body=[
                    #link{class=["pull-left"],
                        body=[#image{class=["media-object"],image="static/flatui/images/illustrations/infinity.png",width= <<"64">>}]
                    },
                    #panel{class=["media-body"],body=[
                    #h4{text="maxim"},
                    #span{text="Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus."}
                ]}
            ]}
        ]},
    
        #textarea{style="width: 50%; margin:20px 20px 20px 20px;"},
        #button{text="Send",class=["btn","btn-primary","btn-large","btn-inverse"]}

        ]}

    ]}
    ].

event(init) -> [];

event(login) -> User = wf:q(user), wf:update(display,User), wf:user(User), wf:redirect("index").
