-module(textboxlist).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").

title() -> [<<"TBL">>].

main() ->
  [#dtl{file= wf:cache(mode),  ext="dtl",bindings=[{title, title()},{body, body()}]}].

body() -> [
    #p{style="width:500px", body=[
        #label{body="Enter tags" },
        #textboxlist{id=first, autocomplete=false},
        #button{id=submit, class=[btn], body= <<"Submit">>, postback={submit, first}, source=[first]}
    ]},
    #p{body=[
      #label{body="What's your favorite programming language?"},
      #textboxlist{id=second},
      #button{id=submit2, class=[btn], body= <<"Submit">>, postback={submit, second}, source= [second]}
    ]}
  ].

control_event("second", _) ->
  error_logger:info_msg("Autocomplete request ~p", [wf:q(term)]),
  SearchTerm = wf:q(term),
  Data = ["Perl", "Php", "Erlang", "Ruby", "Scala", "P1111", "p2", "p3", "p4", "p5", "p6"],
  List = [[
    list_to_binary(T), % Id
    list_to_binary(T), % Bit plain text
    list_to_binary(T), % Bit html
    list_to_binary(T)  % Suggestion item html
  ] || T <- lists:filter(fun(E)-> string:str(string:to_lower(E), string:to_lower(SearchTerm)) > 0 end, Data) ],
  element_textboxlist:process_autocomplete("second", List, SearchTerm).

event(init) -> ok;
event({submit, Id}) ->
  error_logger:info_msg("Textboxlist value: ~p", [wf:q(Id)]);
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]),ok.
