-module(fb_utils).
-include_lib("n2o/include/wf.hrl").
-include_lib("kvs/include/products.hrl").
-include_lib("kvs/include/feeds.hrl").
-include_lib("kvs/include/users.hrl").

-include("records.hrl").

-compile(export_all).

-define(HTTP_ADDRESS, "http://localhost:8000").
-define(FB_APP_ID, "176025532423202"). %sandbox
-define(FB_APP_SECRET, "df0ed1f649bf974189947caf832ffa01"). %sandbox

init()->
  wf:wire(#api{name=setFbIframe, tag=fb}),
  case wf:page_module() of
    login -> init_sdk();
    profile -> init_sdk();
    price_table -> init_sdk();
    _ ->
      case wf:q("__submodule__") of
        "fb" -> init_sdk();
        _-> []
      end
  end.

init_sdk()->
  error_logger:info_msg("init sdk"),
  wf:wire(#api{name=setFbIframe, tag=fb}),
  wf:wire(#api{name=fbAutoLogin, tag=fb}),
  wf:wire(#api{name=fbLogin, tag=fb}),
  wf:wire(#api{name=fbPreLogin, tag=fb}),
  wf:wire(#api{name=fbSignedRequest, tag=fb}),
  wf:wire(#api{name=fbAddAsService, tag=fb}),
  ["<div id=fb-root></div>",
    "<script>window.fbAsyncInit = function() {",
      "FB.init({ appId: '"++ ?FB_APP_ID ++"',",
      "channelUrl: '" ++ ?HTTP_ADDRESS ++ "/static/channel.html',",
      "status: true,",
      "cookie: true,",
      "xfbml: true,",
      "oauth: true",
      "});",
      "FB.getLoginStatus(function(response) {",
        "if(setFbIframe){",
          "var inIframe= top!=self;",
          "setFbIframe(inIframe);",
          "if(inIframe && response.status == 'connected' && fbLogin){",
            "FB.api(\"/me?fields=id,username,first_name,last_name,email,birthday\",",
            "function(response){",
              "fbAutoLogin(response);",
            "});",
          "}",
        "}",
      "});",
    "};",
    "function fb_login(){",
      "console.log('fb_login');",
      "fbPreLogin();",
      "FB.getLoginStatus(function(response){",
        "if(response.status == 'connected'){",
          "console.log(\"User connected to FB, check for registered account\");",
          "if(fbLogin){",
            "console.log('call for login api');"
            "FB.api(\"/me?fields=id,username,first_name,last_name,email,birthday\",",
              "function(response){",
                "console.log(response);",
                "fbLogin(response);",
              "});",
          "}",
        "}else{",
          "FB.login(function(r){",
            "if(r.authResponse){",
              "if(fbLogin){",
                "FB.api(\"/me?fields=id,username,first_name,last_name,email,birthday\",",
                "function(response){fbLogin(response);});",
              "}",
            "}",
          "},{scope: 'email,user_birthday'});",
        "}",
      "});",
    "}",
    "function add_fb_service(){",
      "FB.login(function(resp){",
        "if(resp.authResponse && resp.authResponse.userID){",
          "var uid = resp.authResponse.userID;",
          "FB.ui({",
              "method: 'permissions.request',",
              "perms: 'publish_stream',",
              "display: 'popup'",
            "},",
            "function(response){",
              "if(response && response.perms){",
                "fbAddAsService(uid);",
            "}});",
        "}",
      "}, {scope: 'email,user_birthday'});",
    "};",
    "function fb_feed(Id, Msg, Token){",
      "FB.api('/'+Id+'/feed?access_token='+Token, 'post', {message: Msg }, function(response) {});",
    "};",
    "(function(d){",
    "var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];",
    "if (d.getElementById(id)) {return;}",
    "js = d.createElement('script');",
    "js.id = id;",
    "js.async = true;",
    "js.src = \"//connect.facebook.net/en_US/all.js?v=2\";",
    "ref.parentNode.insertBefore(js, ref);",
    "}(document));",
    "</script>"].

login_btn()-> #panel{class=["btn-group"], body=
  #link{id=loginfb, class=[btn, "btn-primary"], body=[#i{class=["icon-facebook"]}, <<" Facebook">>],  actions= "$('#loginfb').on('click', fb_login);" }}.

logout_btn()-> [#link{body="Logout", postback=logout}].

service_item()->
  case nsm_users:get_user({username, wf:user()}) of
    {error, notfound}-> [];
    {ok, User} ->
      Li = case User#user.facebook_id of
        undefined -> add_service_btn();
        _ -> del_service_btn()
      end,
      #li{id=fbServiceButton, class=png, body=Li}
  end.

add_service_btn()->
  [#image{image="/images/img-51.png"}, #span{body="Facebook"},
   #link{class="btn", body=["<span>+</span>","Add"],
   actions=#event{type=click, actions=#script{script="add_fb_service()"}}}].

del_service_btn()->
  [#image{image="/images/img-51.png"},
   #span{body="Facebook"},
   #link{class="btn", body=["<span>-</span>","Del"],
   postback=fb_remove_service
   }].

test_btn(FbId, Token)->
  [#link{class="btn", body=["<span>-</span>","Test"],
   actions=#event{type=click, actions=#script{script="fb_feed(" ++ FbId ++",\"Test feed\",\"" ++ Token ++"\")"}}
   }].

buy_button(PackageId, OverLimit) when is_atom(OverLimit)->
    #link{class="pay_fb_btn", body="Buy",
    actions=#event{type=click, actions=#script{script="pay_with_fb(\""
      ++ wf:user() ++ "\" ,\""
      ++ PackageId ++ "\","
      ++ atom_to_list(OverLimit) ++");"}}}.

pay_dialog()->
    wf:wire(#api{name=processOrder, tag=fb}),
    wf:wire(#api{name=fbNotifyOverLimit, tag=fb}),
    ["<script type=\"text/javascript\">",
    "var callback = function(data){",
    "if(data['error_code']){",
        "console.log(\"Code: \"+data['error_code'] + \" Message: \"+ data['error_message']);",
        "return false;",
    "}",
    "if(data['order_id']){",
      "if(processOrder){",
        "processOrder(data);",
      "}",
      "return true;",
    "}",
    "};",
    "function pay_with_fb(user, package_id, overlimit){",
%      "if(overlimit && fbNotifyOverLimit){",
%        "fbNotifyOverLimit();",
%      "} else {",
        "FB.ui({",
        "method:'pay',",
        "action:'buy_item',",
        "order_info: {'item_id': package_id, 'user': user},",
        "dev_purchase_params: {'oscif':true} },",
        "callback);",
%      "}",
    "}",
    "</script>"].

event(fb_remove_service)->
  case nsm_users:get_user({username, wf:user()}) of
    {error, notfound} -> wf:redirect("/login");
    {ok, #user{facebook_id=FbId} = User} when FbId =/= undefined->
      case kvs:get(facebook_oauth, FbId) of
        {ok, #facebook_oauth{access_token=Token}} ->
          case Token of
            undefined -> ok;
            T ->
              URL = "https://graph.facebook.com/" ++ FbId ++ "/permissions/publish_stream?access_token="++ T,
              httpc:request(delete, {URL, []}, [], [])
          end,
          kvs:delete(facebook_oauth, FbId);
          %nsx_msg:notify(["system", "delete"], #facebook_oauth{user_id=FbId});
        {error, notfound} -> ok
      end,
      kvs:delete(user_by_facebook_id, FbId),
      %nsx_msg:notify(["system", "delete"], {user_by_facebook_id, FbId}),
      kvs:put(User#user{facebook_id=undefined}),
      %nsx_msg:notify(["system", "put"], User#user{facebook_id=undefined}),
      wf:update(fbServiceButton, add_service_btn());
    _ -> no_service
  end;
event(Event)->
  error_logger:info_msg("Fbutils: ~p", [Event]).
api_event(fbPreLogin, _, _)->
  error_logger:info_msg("Prefucking login"),
  wf:session(fb_registration, undefined);
api_event(fbAutoLogin, Args, Term)->
  api_event(fbLogin, Args, Term);
api_event(fbLogin, Args, _Term)->
  error_logger:info_msg("Login args: ~p", [Args]),
  case Args of
    [{error, E}] ->
      ErrorMsg = io_lib:format("Facebook error:~p", [E]),
      wf:redirect("/index/message/" ++ site_utils:base64_encode_to_url(ErrorMsg));
    _ ->
      CurrentUser = wf:user(),
      FbId = proplists:get_value(id, Args),
      UserName = case proplists:get_value(username, Args) of
        A when is_atom(A) -> atom_to_list(A);
        N -> N
      end,
      BirthDay = case proplists:get_value(birthday, Args) of
        undefined -> {1, 1, 1970};
        BD -> list_to_tuple([list_to_integer(X) || X <- string:tokens(BD, "/")])
      end,
      error_logger:info_msg("Facebook id ~p username: ~p", [FbId, re:replace(UserName, "\\.", "_", [{return, list}])]),
      case kvs:all_by_index(user, facebook_id, FbId) of
        [] ->
          RegData = #user{
            username = re:replace(UserName, "\\.", "_", [{return, list}]),
            avatar = "https://graph.facebook.com/" ++ UserName ++ "/picture?width=50&height=50",
            password = undefined,
            email = proplists:get_value(email, Args),
            name = proplists:get_value(first_name, Args),
            surname = proplists:get_value(last_name, Args),
            facebook_id = FbId,
            team = kvs_meeting:create_team("tours"),
            verification_code = undefined,
            age = {element(3, BirthDay), element(1, BirthDay), element(2, BirthDay)},
            register_date = erlang:now(),
            sex = undefined,
            status = ok
          },
          case kvs_user:register(RegData) of
            {ok, Name} ->
              error_logger:info_msg("Registered name: ~p", [Name]),
              login:login_user(Name);
            {error, _Error} ->
              Msg = "This email it taken by other user. If You already have the kakaranet.com account, please login and connect the to facebook.",
              wf:session(fb_registration, Args),
              wf:redirect("/login/register/msg/"++site_utils:base64_encode_to_url(Msg))
          end;
        [User|_] when element(2,User) == CurrentUser -> ok;
        [User|_] -> login:login_user(element(2, User))
      end
  end;
api_event(fbNotifyOverLimit, _, _)->
    buy:over_limit_popup(nsm_membership_packages:get_monthly_purchase_limit());
api_event(processOrder, _, [[{order_id, OrderId}, {status, Status}]])-> 
  error_logger:info_msg("Payment complete. Order:~p~n", [OrderId]),
  case nsm_membership_packages:get_purchase(integer_to_list(OrderId)) of
    {ok, Purchase} when Status =:= "settled" ->
      nsx_msg:notify(["purchase", "user", wf:user(), "set_purchase_state"], {element(2,Purchase), done, facebook}),
      wf:redirect("/profile/account");
    _ -> wf:info("Purchase Not Found")
  end;
api_event(setFbIframe, IsIframe, _) ->
  error_logger:info_msg("Is iframe: ~p", [IsIframe]),
  wf:session(is_facebook, IsIframe),
  LogoutBtn = case IsIframe of
    true -> [];
    _ -> #li{body=[#link{body="Logout", postback=logout}]}
  end,
  wf:update(logout_btn, LogoutBtn);
api_event(fbSignedRequest, _, _Data) -> ok;
api_event(fbAddAsService, _, [Id])->
  case nsm_users:get_user({username, wf:user()}) of
    {error, notfound} -> wf:redirect("/login");
    {ok, User} when User#user.facebook_id =/= Id->
      case nsm_users:get_user({facebook, Id}) of
        {error, notfound}-> ok;
        {ok, ExUser} when ExUser#user.username =/= User#user.username ->
          kvs:put(ExUser#user{facebook_id=undefined});
          %nsx_msg:notify(["system", "put"], ExUser#user{facebook_id=undefined});
        _-> ok
      end,
      kvs:put(User#user{facebook_id=Id}),
      %nsx_msg:notify(["system", "put"], User#user{facebook_id=Id}),
      update_access_token(Id);
    {ok, User} -> update_access_token(User#user.facebook_id)
  end.

update_access_token(Id)->
  nsx_msg:notify(["db", "user", wf:user(), "put"], #facebook_oauth{user_id=Id, access_token=get_access_token()}),
  wf:update(fbServiceButton, del_service_btn()).

get_access_token()->
  Url = "https://graph.facebook.com/oauth/access_token?client_id=" ++ ?FB_APP_ID
    ++ "&client_secret=" ++?FB_APP_SECRET
    ++ "&grant_type=client_credentials",
  case send_request(Url) of
    {ok, Resp} ->
      [_|Token] = string:tokens(Resp, "="),
      wf:url_encode(lists:flatten(Token));
    {error, _} -> undefined
  end.

send_request(Uri) ->
  error_logger:info_msg("send_request(~p)~n~n", [Uri]),
  case httpc:request(Uri) of
    {ok, {_, Header, Data}} ->
      case string:tokens(proplists:get_value("content-type", Header), ";") of
        ["text/javascript" | _Rest] -> {ok, mochijson2:decode(Data)};
        [Type | _Rest] -> wf:info("Type:~p~n", [Type]), {ok, Data}
      end;
    {error, _} = E -> E
  end.

feed(UserName, Msg)->
  case kvs:get(user, UserName) of
    {error, notfound}-> fail;
    {ok, #user{facebook_id=FacebookId}} when FacebookId =/= undefined->
      case kvs:get(facebook_oauth, FacebookId) of
        {error, notfound}-> fail;
        {ok, #facebook_oauth{} = FO}->
          AccessToken = case FO#facebook_oauth.access_token of
            undefined ->
              AT = get_access_token(),
              nsx_msg:notify(["db", "user", UserName , "put"], #facebook_oauth{user_id=FacebookId, access_token=AT});
            AT -> AT
          end,
          Url ="https://graph.facebook.com/"++ FacebookId ++"/feed",
          Body = "access_token="++AccessToken++"&message="++ wf:url_encode(Msg),
          httpc:request(post, {Url, [], "application/x-www-form-urlencoded", Body}, [], [])
      end;
    _ -> fail
  end.