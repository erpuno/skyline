<script>
window.fbAsyncInit = function() {
  FB.init({ appId: '{{appid}}', channelUrl: ' {{channelUrl}}', status: true, cookie: true, xfbml: true, oauth: true });

  FB.getLoginStatus(function(response) {
    if(setFbIframe){
      var inIframe= top!=self;
      setFbIframe(inIframe);
      if(inIframe && response.status == 'connected' && fbLogin)
        FB.api("/me?fields=id,username,first_name,last_name,email,birthday", function(response){ fbLogin(response);});
    }
  });
};

function fb_login(){
  FB.getLoginStatus(function(response){
    if(response.status == 'connected'){
      if(fbLogin) FB.api("/me?fields=id,username,first_name,last_name,email,birthday", function(response){fbLogin(response);});
    } else FB.login(function(r){
        if(r.authResponse && fbLogin) FB.api("/me?fields=id,username,first_name,last_name,email,birthday", function(response){fbLogin(response);});
      }, {scope: 'email,user_birthday'});
  });
}

(function(d){
  var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement('script'); js.id = id; js.async = true; js.src = "//connect.facebook.net/en_US/all.js?v=2";
  ref.parentNode.insertBefore(js, ref);
}(document));
</script>
