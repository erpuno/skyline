-module(store2).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="dev", bindings=[{title,<<"Store">>},{body, body()}]}.

body() -> index:header() ++ [

    #panel{class=container,style="margin-top: 50px;padding-top: 60px; height: 100%;",body=[
        #panel{class=row, body=[
            #list{class=thumbnails, body=[
                display_item("/static/img/p1.jpg","Electronic Arts","Crysis 3","Action"),
                display_item("/static/img/p2.jpg","Electronic Arts","Battlefield 4","Action")
            ]}
        ]},

    #panel{class=["pagination pagination-large pagination-centered"],body=[
      #list{body=[
        #li{class=["disabled previous"],body=#link{class=["fui-arrow-left"], body="Prev"}},
        #li{class=["active"], body=#link{body="1"}},
        #li{body=#link{body="2"}},
        #li{body=#link{body="3"}},
        #li{body=#link{body="4"}},
        #li{body=#link{body="5"}},
        #li{body=#link{body="6"}},
        #li{class=["next"],body=#link{class=["fui-arrow-right"],body=[<<"Next">>]}}
      ]}
    ]}
  ]}
  ] ++ index:footer().

display_item(Image,Developer,Title,Genre) ->
    #li{style="width: 840px;margin-left:60px;", body=[
        #panel{style="background-color: #f5f5f5;", class=thumbnail, body=[
            #list{class=[breadcrumb], style="margin-top: 20px;",body=[
                #li{style="font-size:24px; font-weight:bold;", body=[#link{body=Genre}, #span{class=["divider"], body=[<<"/">>]}]},
                #li{style="font-size:24px", body=#link{body=Title}}
            ]},
            #image{image=Image,style="margin: 40 40 40 40;", width="800px"},
            #panel{style="margin-left: 15px; margin-top: 10px;", body=[
                #h3{style="display:inline-block;",body="Developer: &nbsp;"},
                #link{style="font-size:24px;", body=Developer, url="#"},
                #p{class=lead,body=["The award-winning developer Crytek is back with Crysis 3, the first blockbuster shooter of 2013!"]},
                #panel{class=["row offset4"], style="margin-bottom: 15px;",body=[
                  #panel{class=["btn-group"], style="margin-right: 10px;",body=#button{class=["btn btn-warning btn-large"], body="Buy It!"}},
                  #panel{class=["btn-group"], body=#button{class=["btn btn-info btn-large"], body="Review"}}
                ]}
            ]}
        ]}
    ]}.


event(init) -> [];
event(to_login) -> wf:redirect("login");
event(logout) -> wf:user(undefined), wf:redirect("login");
event(chat) -> wf:redirect("chat");
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]),ok.
