module OmniAuth
  module Strategies
    class VkontakteOpenApi
      class ViewHelper
        module PageHelper
          def vkontakte_login_page
            vkontakte_header +
            vkontakte_login_button +
            vkontakte_footer
          end

          def vkontakte_header
<<-HEADER
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
  <html xmlns="http://www.w3.org/1999/xhtml"> 
  <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>Вход во ВКонтакте</title>
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
  </head> 
  <body>
HEADER
          end
          
          def vkontakte_login_button
<<-BUTTON
<div id="vk_api_transport"></div>
<script type="text/javascript">
  window.vkAsyncInit = function() {
        /*VK.Observer.subscribe('auth.login', function(response) {
          window.location = '/omniauth/vkontakte/callback';
        });*/
    VK.init({
      apiId: #{OmniAuth.config.vkontakte_app_id},
      nameTransportPath: "/xd_receiver.html"
    });
    VK.UI.button('vk_login');
  };
  LOGINZA = {
    vkLoginResult: function (r) {
      //console.log('called vkLoginResult');
      if (r.session && r.session.expire != "0") {
        LOGINZA.vkGetUserProfile(LOGINZA.vkPutUserProfile)
      } else if (r.session.expire == "0") {
        //console.log('VK.bugFix recall login');
        VK.Observer.subscribe("auth.sessionChange", function (r) {
          //console.log('called bugFuxFunc');
          VK.Observer.unsubscribe("auth.sessionChange");
          if (r.session && r.session.expire != "0") {
            LOGINZA.vkGetUserProfile(LOGINZA.vkPutUserProfile)
          } else {
            //console.log("FAILED")
          }
        });
        VK.Auth.login()
      }
    },
    vkGetUserProfile: function (callFunc) {
      //console.log('called vkGetUserProfile');
      var code;
      code = 'return {';
      code += 'me: API.getProfiles({uids: API.getVariable({key: 1280}), fields: "nickname,sex,bdate,city,country,photo,photo_big,has_mobile,rate,home_phone,mobile_phone"})[0]';
      code += '};';
      VK.Api.call('execute', {
        'code': code
      },
      callFunc);
    },
    vkPutUserProfile: function (data) {
      //console.log('called vkPutUserProfile');
      if (data.response) {
        r = data.response;
        $.ajax({
          type: "POST",
          url: '#{OmniAuth.config.path_prefix}/vkontakte/callback',
          data: r.me,
          success: function () {
            document.location.reload();
          }
        });
        //console.log(data);
      }
    }
	};
  window.doLogin = function() {
    VK.Auth.login(LOGINZA.vkLoginResult);
  };
  (function() {
    var el = document.createElement("script");
    el.type = "text/javascript";
    el.charset = "windows-1251";
    el.src = "http://vkontakte.ru/js/api/openapi.js";
    el.async = true;
    document.getElementById("vk_api_transport").appendChild(el);
  }());
</script>
<div id="vk_login" style="margin: 0 auto 20px auto;" onclick="doLogin();"></div>
BUTTON
          end

          def vkontakte_footer
<<-FOOTER
  </body></html>
FOOTER
          end
        end
      end
    end
  end
end
