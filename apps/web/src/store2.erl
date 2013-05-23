-module(store2).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

title() -> [<<"Store2">>].

main() ->
  Title = wf:render(title()),
  Body = wf:render(body()),
  [#dtl{file="store2", bindings=[{title,Title},{body, Body}]}].

body() -> [
  #panel{class=[navbar, "navbar-inverse", "navbar-fixed-top"], body=[
    #panel{class=["navbar-inner"], body=[
      #panel{class=[container], body=[
        #link{class=[brand], url="#", text="Synrc App Store" }
      ]}
    ]}
  ]}
  ].

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]),ok.