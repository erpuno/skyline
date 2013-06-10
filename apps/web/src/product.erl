-module(product).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include("records.hrl").

-define(PAGE_SIZE, 4).


main() -> #dtl{file="dev", bindings=[{title,<<"product">>},{body, body()}]}.

body() ->
%  Qid = wf:qs(<<"id">>),
%  Product = case [P || #product{id=Id} = P  <- wf:session(products), Id == list_to_integer(binary_to_list(Qid))] of [] -> []; L -> lists:nth(1,L) end,
  Product = product(),

  index:header()++[
  #panel{class=["container"], body=[
    #panel{class=["row-fluid"], body=[
      #panel{class=[span4, "product-view"], body=products:product(Product)},
      #panel{class=[span8], body=#list{class=[thumbnails], body=feed()} }
    ]}
  ]}
  ]++index:footer().

feed() -> [#feed_entry{entry=E} || E <- entries(), _I <- lists:seq(1, 5)].

event(init) -> [];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).

entries()-> [
  #entry{
    id={1,1},
    description= <<"The award-winning developer Crytek is back with Crysis 3, the first blockbuster shooter of 2013!">>,
    from= <<"Pupkin">>,
    created = calendar:local_time(),
    type= {product, normal},
    media= [
      #media{
        id=1,
        type = image,
        title= <<"Media1">>,
        html= <<"<b>Media1</b>">>,
        url = <<"/static/img/p1.jpg">>,
        thumbnail_url = <<"/static/img/p1.jpg">> }] }].

product()->
    #product{
      id=1,
      name = list_to_binary("Name " ++ integer_to_list(1)),
      categories= [1],
      description_short= <<"Description header ">>,
      description_long= <<"Very long description Very long description Very long description">>,
      image_small_url = "/static/img/item-bg.png",
      image_big_url="/static/img/item-bg.png",
      publish_start_date = calendar:local_time(),
      publish_end_date =  calendar:local_time(),
      price=1000,
      our_price=999,
      creation_date= calendar:local_time()}.
