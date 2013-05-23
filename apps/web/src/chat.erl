-module(chat).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> [ #dtl{file = "tblist", bindings=[{title,<<"Login">>},{body,wf:render(body())}]} ].

body() -> store2:header() ++ [
    #panel{class=container,style="background-color: #f5f5f5;padding: 30px; width: 800px; margin-left: 100px; margin-top: 100px;",body=[
    #panel{class=row,body=[

        #panel{class=["media"],style="width:800px;",body=[
            #link{class=["pull-left"],
                body=[#image{class=["media-object"],image="static/flatui/images/illustrations/infinity.png",width= <<"64">>}]
            },
            #panel{class=["media-body"],body=[
                #h4{text="doxtop"},
                #span{text="Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus."}
            ]}
        ]},
        #panel{class=["media"],style="width:800px;",body=[
            #link{class=["pull-left"],
                body=[#image{class=["media-object"],image="static/flatui/images/illustrations/infinity.png",width= <<"64">>}]
            },
            #panel{class=["media-body"],body=[
                #h4{text="maxim"},
                #span{text="Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus."}
            ]}
        ]}
    ]},

    #textarea{style="width: 50%; height: 34px;margin-top:8px; margin-left:100px; margin-right: 10px;"},
    #button{text="Send",class=["btn","btn-primary","btn-large","btn-inverse"]}

    ]}
    ].

event(init) -> [];

event(login) -> User = wf:q(user), wf:update(display,User), wf:user(User), wf:redirect("index").
