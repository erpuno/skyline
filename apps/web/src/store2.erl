-module(store2).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="tblist", bindings=[{title,<<"Store">>},{body, wf:render(body())}]}.

header() -> [
  #panel{class=[navbar, "navbar-inverse", "navbar-fixed-top"], body=[
    #panel{class=["navbar-inner"], body=[
      #panel{class=[container], body=[
        #link{class=[brand], url="/login", text="Synrc App Store", name="top" },
        #panel{class=["nav-collapse collapse"],body=[
          #list{class=[nav], body=[
            #li{body=#link{body=[ #i{class=["fui-chat", "icon-comment"]}, #span{class=["badge badge-info"], text="10"} ]}},
            #li{body=#link{body=[ #i{class=["fui-mail", "icon-envelope"]}, #span{class=["badge badge-info"], text="21"} ]} },
            #li{body=#link{body=[ #i{class=["fui-search", "icon-search"]} ]}},
            #li{body=#link{body=["Home"],url="/chat"}},
            #li{body=#link{body=["Games"],url="/store2"}},
            #li{body=#link{body=["Review"]}}
          ]},
          #panel{class=["pull-right"], body=[
            #list{class="nav pull-right", body=[
              #li{body=[
                #link{class=["dropdown-toggle"], data_fields=[{<<"data-toggle">>, <<"dropdown">>}], body=[
                  "My Account",
                  #b{class=["caret"]}
                ]},
                #list{class=["dropdown-menu"], body=[
                  #li{body=#link{body=[#i{class=["icon-cog", "fui-gear"]},  " Preferences"]}},
                  #li{body=#link{body=[#i{class=["icon-off"]}, " Logout" ]}}
                ]} ]} ]} ]} ]} ]} ]} ]}
   ].


display_item(Image,Developer,Title,Genre) ->
    #li{style="width: 840px;margin-left:60px;", body=[
        #panel{style="background-color: #f5f5f5;", class=thumbnail, body=[
            #list{class=breadcrumb, style="margin-top: 20px;",body=[
                #li{style="font-size:24px; font-weight:bold;", body=[#link{text=Genre}, #span{class=["divider"], body=["/"]}]},
                #li{style="font-size:24px", body=#link{text=Title}}
            ]},
            #image{image=Image,style="margin: 40 40 40 40;", width="800px"},
            #panel{style="margin-left: 15px; margin-top: 10px;", body=[
                #h3{style="display:inline-block;",text="Developer: &nbsp;"},
                #link{style="font-size:24px;", text=Developer, url="#"},
                #p{class=lead,body=["The award-winning developer Crytek is back with Crysis 3, the first blockbuster shooter of 2013!"]},
                #panel{class=["row offset4"], body=[
                  #panel{class=["btn-group"], style="margin-right: 10px;",body=#button{class=["btn btn-warning btn-large"], text="Buy It!"}},
                  #panel{class=["btn-group"], body=#button{class=["btn btn-info btn-large"], text="Review"}}
                ]}, #br{}
            ]}
        ]}
    ]}.

body() -> header() ++ [

    #panel{class=container,style="margin-top: 50px;padding-top: 60px; height: 100%;",body=[
        #panel{class=row, body=[
            #list{class=thumbnails, body=[
                display_item("/static/img/p1.jpg","Electronic Arts","Crysis 3","Action"),
                display_item("/static/img/p2.jpg","Electronic Arts","Battlefield 4","Action")
            ]}
        ]},

    #panel{class=["pagination pagination-large pagination-centered"],body=[
      #list{body=[
        #li{class=["disabled previous"],body=#link{class=["fui-arrow-left"], text="Prev"}},
        #li{class=["active"], body=#link{text="1"}},
        #li{body=#link{text="2"}},
        #li{body=#link{text="3"}},
        #li{body=#link{text="4"}},
        #li{body=#link{text="5"}},
        #li{body=#link{text="6"}},
        #li{class=["next"],body=#link{class=["fui-arrow-right"],text="Next"}}
      ]}
    ]},
    #footer{style="background:white;", class=["text-center"],body=
      #panel{body=[
        #hr{},
        #panel{class=["row-fluid"], body=[
          #panel{class=[span12], body=[
            #panel{class=["span8"], body=[
              #link{class=["btn btn-link"],text="About"},
              #link{class=["btn btn-link"],text="Help"},
              #link{class=["btn btn-link"],text="Terms of Use"},
              #link{class=["btn btn-link"],text="Privacy"},
              #link{class=["btn btn-link"],text="RSS"}
            ]},
            #panel{class=["span4"], style="margin-top:10px;margin-bottom:10px;",body=[
              #span{style="margin-right:2px;vertical-align:middle;",body="&copy;"},
              #link{class=[""],url="http://synrc.com", text="synrc.com"}
            ]}
          ]}
        ]}
      ]}
    }
  ]} ].

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]),ok.