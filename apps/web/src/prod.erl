-module(prod).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/users.hrl").
-include_lib("kvs/include/feeds.hrl").
-include_lib("kernel/include/file.hrl").
-include("records.hrl").

-define(PAGE_SIZE, 4).
-record(product_hero, {?ELEMENT_BASE(prod), product=[]}).
-record(product_price, {?ELEMENT_BASE(prod), product=[]}).
-record(product_entry, {?ELEMENT_BASE(prod), entry=[]}).
-record(entry_media, {?ELEMENT_BASE(prod), media=[], fid}).

-define(ROOT, code:priv_dir(web)++"/static/").

main() -> #dtl{file="dev", ext="dtl", bindings=[{title,<<"product">>},{body, body()}]}.

body() ->
  wf:session(medias, undefined),
  Id = case wf:qs(<<"id">>) of undefined -> 0; I -> list_to_integer(binary_to_list(I)) end,
  Product = case kvs:get(product, Id) of
    {ok, P} -> P;
    {error, not_found} -> wf:redirect("/404")
  end,
  index:header()++[
    #section{class=[section, alt], body=[#panel{class=[container], body=[ #product_hero{product=Product} ]} ]},
    #section{class=[section], body=[#panel{class=[container], body=[feed_detail()]}]},
    #section{class=[section, static], body=#panel{class=[container], body=entry_form(Product)}},
    #section{class=[section], body=#panel{class=[container], body=[#panel{class=["row-fluid"], body=[
      #panel{class=[span9], body=feed(Product)},
      #panel{class=[span3], body=[]}
    ]} ]} }
  ] ++index:footer().

feed_essential()-> [].
feed_detail() -> [
  #list{class=[nav, "nav-tabs", "sky-nav", "entry-type-tabs"], body=[
    #li{class=[active], body=[#link{url= <<"#overview">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Overview">>}]},
    #li{body=[#link{url= <<"#features">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Features">>}]},
    #li{body=[#link{url= <<"#specs">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Specification">>}]},
    #li{body=[#link{url= <<"#gallery">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Gallery">>}]},
    #li{body=[#link{url= <<"#trailers">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Videos">>}]},
    #li{body=[#link{url= <<"#reviews">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Reviews">>}]},
    #li{body=[#link{url= <<"#news">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"News">>}]},
    #li{body=[#link{url= <<"#bundles">>, data_fields=[{<<"data-toggle">>, <<"tab">>}], body= <<"Bundles">>}]}
  ]},
  #panel{class=["tab-content"], body=[
    #panel{id=overview, class=["tab-pane", active], body=[]},
    #panel{id=features, class=["tab-pane"], body=[]},
    #panel{id=specs, class=["tab-pane"], body=[]},
    #panel{id=gallery, class=["tab-pane"], body=[]},
    #panel{id=trailers, class=["tab-pane"], body=[]},
    #panel{id=reviews, class=["tab-pane"], body=[]},
    #panel{id=news, class=["tab-pane"], body=[]},
    #panel{id=bundles, class=["tab-pane"], body=[]}
  ]}
].

entry_form(P) ->
  Id = wf:temp_id(),
  [
  #h3{body="post review"},
  #panel{class=["row-fluid"], body=[
    #panel{class=[span10], body=[
      #textbox{id=title, class=[span12], placeholder= <<"Title">>},
      #htmlbox{id=descr, class=[span12]}
    ]},
    #panel{class=[span2], body=[
      #select{name="type", id=type, body=[
        #option{value=overview,  body= <<"Overview">>},
        #option{value=features,  body= <<"Features">>},
        #option{value=specs,  body= <<"Specification">>},
        #option{value=gallery, body= <<"Galery">>},
        #option{value=trailers, body= <<"Videos">>},
        #option{value=reviews, body= <<"Reviews">>},
        #option{value=news, body= <<"News">>},
        #option{value=bundles, body= <<"Bundles">>}
      ]}
      %#upload{id=upload, delegate=prod, root=code:priv_dir(web)++"/static"}
    ]}
  ]},
  #panel{class=["btn-toolbar"], body=[#link{id=save, postback={post_entry, P#product.feeds, P#product.id}, source=[descr, title], class=[btn, "btn-large", "btn-success"], body= <<"Post">>}]} ].

feed(P) ->
  Entries = kvs_feed:entries(P#product.feeds, undefined, 10),
%  error_logger:info_msg("Render feed: ~p", [Entries]),
  [#product_entry{entry=E} || E <- Entries].

comment() -> comment([]).
comment(InnerComment)->
  #panel{class=[media, "media-comment"], body=[
    #link{class=["pull-left"], body=[
      #image{class=["media-objects","img-circle"], data_fields=[{<<"data-src">>, <<"holder.js/64x64">>}]}
    ]},
    #panel{class=["media-body"], body=[
      #p{class=["media-heading"], body=[
        <<"John Doe, 12 Sep 2012.">>, 
        #link{class=["comment-reply","pull-right"], body= <<"reply">>}
      ]},
      #p{body= <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.">>},
      InnerComment
    ]}
  ]}.

render_element(#product_hero{product=P})->
  wf:wire(wf:f("var c = $('#title_pic')[0];
    c.style.width='100%';
    c.style.height='100%';
    c.width  = c.offsetWidth;
    c.height = c.offsetHeight;
    if(c.height>470){c.height=470;c.style.height='470px'};

    var context = c.getContext('2d');
    var img = new Image();
    var dw, dh, wi, he;

    img.onload = function(){
      if(img.width > c.width){
        dw = (img.width-c.width)/2; 
        wi = c.width;
      }else{
        dw = 0;
        wi = img.width;
      }

      if(img.height > c.height){
        dh = (img.height-c.height)/2;
        he = c.height;
      }else{
        dh = 0;
        he = img.height;
      };
      context.drawImage(img, dw, dh, wi, he, 0, 0, c.width, c.height);
    };
    img.src = '~s';
  ", [P#product.cover])),
  Hero = #panel{class=["row-fluid"], body=[
    #panel{class=[span6], body=[
      #panel{class=["hero-unit"], body=[
        #h1{body=P#product.title},
        #p{class=[brief], body=P#product.brief},
        #product_price{product=P}
%        #link{class=[btn, "btn-large", "btn-info"], body= <<"buy it">>, postback={product, integer_to_list(P#product.id)}}
      ]}
    ]},
    #panel{class=[span6], style="position:relative;height:100%;padding-top:60px;",  body= <<"<canvas id='title_pic' style='border:1px solid;'></canvas>">>}
  ]},
  element_panel:render_element(Hero);
render_element(#product_price{product=P}) ->
  {PriceHead, PriceClass, BtnClass} = case P#product.price of % case for featured product
      true  ->  {<<"Featured">>, ["pricing-table-featured", "product-price-featured"], []};
      false  -> {<<"Featured">>, ["pricing-table-featured", "product-price-featured", "featured-orange"], []};
      _ ->      {<<"Standard">>, [], ["btn-info"]}
  end,

  Panel =#panel{class=["well","pricing-table", "product-price", span6, "text-center"]++PriceClass, body=[
        #h3{body=#span{body=PriceHead}},
        #h2{class=["pricing-table-price", "product-price-price"], body=[#span{body= <<"$">>}, list_to_binary(io_lib:format("~.2f", [P#product.price]))]},

        #list{class=["pricing-table-list", "product-price-list"], body=[
          #li{body= [#checkbox{id=win, body = <<"PC download">>}]},
          #li{body= [#checkbox {id=ps3, body = <<"PLAYSTATION&reg;3">>}]}
        ]},
        #button{class=[btn, "btn-large"]++BtnClass, body= <<"buy it">>, postback={product, integer_to_list(P#product.id)}}
      ]},
  element_panel:render_element(Panel);
render_element(#product_entry{entry=E})->
  Ms = E#entry.media,
  error_logger:info_msg("Entry: ~p", [Ms]),
  {{Y, M, D}, _} = calendar:now_to_datetime(E#entry.created),
  Date = io_lib:format(" ~p ~s ~p ", [D, element(M, {"Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"}), Y]),
  Entry = #panel{class=["blog-post"], body=[
    #header{class=["blog-header"], body=[
          #h2{body=[E#entry.title, #small{body=[<<" by ">>, #link{body=E#entry.from}, Date]}]}
    ]},
    #figure{class=["thumbnail-figure"], body=[
      [#entry_media{media=Me, fid=E#entry.entry_id} || Me <- Ms],
          #figcaption{class=["thumbnail-title"], body=[
            #h3{body=#span{body= E#entry.title}}
          ]}
    ]},
    #p{body= E#entry.description},
    #footer{class=["blog-footer", "row-fluid"], body=[
          #panel{class=[span4, "blog-categories"], body=[#i{class=["icon-pushpin"]}, #link{body= <<" consectetur">>}]},
          #panel{class=[span4, "blog-tags"], body=[#i{class=["icon-tags"]}, #link{body= <<" fugiat, nulla, pariatur">>}]},
          #panel{class=[span4, "blog-more"], body=[#i{class=["icon-link"]}, #link{body= <<" read more">>}]}
    ]}
  ]},
  element_panel:render_element(Entry);
render_element(#entry_media{media=M})->
  I = #image{image="/static/"++M#media.title}, element_image:render_element(I).

description(Id, Description) -> [
  #panel{id="description"++Id, body=[
    #panel{class=[collapse, in], body= <<"Description head">>},
    #panel{id=Id, class=collapse, body= Description}
  ]},
  #button{class=[btn, "btn-link"], data_fields=[
    {<<"data-toggle">>, <<"collapse">>},
    {<<"data-target">>, list_to_binary("#"++Id) },
    {<<"data-parent">>, list_to_binary("#description"++Id)}], body= <<"Read...">>}].

event(init) -> [];
event({counter,C}) -> wf:update(onlinenumber,wf:to_list(C));
event({post_entry, Fid, Id}) ->
  Entry = wf:q(descr),
  Title = wf:q(title),
  Type =  wf:q(type),
  error_logger:info_msg("Entry ~p ~p ~p", [Title, Entry, Type]),
  Recipients = [{Id, product}],
  SharedBy = "",
  Type = {product, Type},
  Medias = case wf:session(medias) of undefined -> []; L -> L end,
  error_logger:info_msg("Medias to save ~p", [Medias]),
  Desc = Entry,
  Title1 = Title,
  EntryId = uuid(),
  User = wf:user(),
  From = User#user.username,
  [begin
    % Route = [feed, product, ProductId, entry, uuid(), add]
    % Message = [Product, Destinations, Desrciption, Medias]
    kvs_feed:add_entry(Fid, From, To, EntryId, Title1, Desc, Medias, Type, SharedBy)
  end || {To, _RoutingType} <- Recipients];
event(Event) -> error_logger:info_msg("Page event: ~p", [Event]), [].

api_event(Name,Tag,Term) -> error_logger:info_msg("Name ~p, Tag ~p, Term ~p",[Name,Tag,Term]), event(change_me).

control_event("upload", File, _Data) ->
  error_logger:info_msg("Process file ~p", [File]),
  ok.

process_file(Name) ->
  U = wf:user(),
  {ok, Type} = identify(?ROOT++Name),
  {ok, {id=hash_from_file(?ROOT++Name), 
    name = Name,
    file=?ROOT++Name,
    owner = U#user.username,
    type = Type,
    data={create_date, now()}}}.

hash_from_file(Filename) ->
    {ok, Content} = file:read_file(Filename),
    <<Hash:160/integer>> = crypto:sha(Content),
    lists:flatten(io_lib:format("~40.16.0b", [Hash])).

identify(Filename) ->
  Info = os:cmd("file -b --mime-type " ++ Filename),
  Result = case re:run(Info, "^[a-zA-Z0-9_\\-\\.]+/[a-zA-Z0-9\\.\\-_]+", [{capture, first, list}]) of
     nomatch -> {error, Info};
     {match, [Type|_]} -> {ok, Type}
  end,
  Result.

uuid() ->
  R1 = random:uniform(round(math:pow(2, 48))) - 1,
  R2 = random:uniform(round(math:pow(2, 12))) - 1,
  R3 = random:uniform(round(math:pow(2, 32))) - 1,
  R4 = random:uniform(round(math:pow(2, 30))) - 1,
  R5 = erlang:phash({node(), now()}, round(math:pow(2, 32))),

  UUIDBin = <<R1:48, 4:4, R2:12, 2:2, R3:32, R4: 30>>,
  <<TL:32, TM:16, THV:16, CSR:8, CSL:8, N:48>> = UUIDBin,

  lists:flatten(io_lib:format("~8.16.0b-~4.16.0b-~4.16.0b-~2.16.0b~2.16.0b-~12.16.0b-~8.16.0b",
                              [TL, TM, THV, CSR, CSL, N, R5])).

