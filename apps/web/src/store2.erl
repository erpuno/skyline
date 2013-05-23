-module(store2).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file="store2", bindings=[{title,<<"Store">>},{body, wf:render(body())}]}.

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