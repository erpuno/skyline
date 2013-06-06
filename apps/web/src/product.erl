-module(product).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").

main() -> #dtl{file="dev", bindings=[{title,<<"product">>},{body, body()}]}.

body() ->
  Qid = wf:qs(<<"id">>),
  Product = case [P || #product{id=Id} = P  <- wf:session(products), Id == list_to_integer(binary_to_list(Qid))] of [] -> []; L -> lists:nth(1,L) end,
  error_logger:info_msg("P =  ~p~n", [Product]),

  index:header()++[
  #panel{class=["container"], body=[
    #panel{class=["row-fluid"], body=[
      #panel{class=span4, body=[
        #link{class=["product-image"], body=#image{class=["img-polaroid"], image=Product#product.image_small_url}}
      ]},
      #panel{class=[span8], body=[
        <<"xx">>
      ]}
    ]}
  ]}
  ]++index:footer().

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).
