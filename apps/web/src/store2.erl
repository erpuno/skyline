-module(store2).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="store2", bindings=[{title,<<"Store">>},{body, wf:render(body())}]}.

body() -> [
  #panel{class=[navbar, "navbar-inverse", "navbar-fixed-top"], body=[
    #panel{class=["navbar-inner"], body=[
      #panel{class=[container], body=[
        #link{class=[brand], url="#", text="Synrc App Store", name="top" },
        #panel{class=["nav-collapse collapse"],body=[
          #list{class=[nav], body=[
            #li{body=#link{body=[ #i{class=["fui-chat", "icon-comment"]}, #span{class=["badge badge-info"], text="10"} ]}},
            #li{body=#link{body=[ #i{class=["fui-mail", "icon-envelope"]}, #span{class=["badge badge-info"], text="21"} ]} },
            #li{body=#link{body=[ #i{class=["fui-search", "icon-search"]} ]}},
            #li{body=#link{body=["Home"]}},
            #li{body=#link{body=["Games"]}},
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
                ]}
              ]}
            ]}
          ]}
        ]}
      ]}
    ]}
  ]}
  ].

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]),ok.