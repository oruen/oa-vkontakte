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
  </head> 
  <body>
HEADER
          end
          
          def vkontakte_login_button
<<-BUTTON
<div id="vk_api_transport"></div>
<script type="text/javascript">
  window.vkAsyncInit = function() {
    VK.init({
      apiId: '#{OmniAuth.config.vkontakte_app_id}',
      nameTransportPath: "/xd_receiver.html"
    });
    VK.UI.button('vk_login');
  };
  vkLogin = {
    doLogin: function() {
      VK.Auth.login(vkLogin.loginResult);
    },
    redirectWithPost: function(url, data) {
      method = "POST";
      data = data || {};
      var form = document.createElement("form"),
          input;
      form.setAttribute("action", url);
      form.setAttribute("method", "POST");
  
      for (var property in data) {
        if (data.hasOwnProperty(property)) {
          var value = data[property];
          if (value instanceof Array) {
            for (var i = 0, l = value.length; i < l; i++) {
              input = document.createElement("input");
              input.setAttribute("type", "hidden");
              input.setAttribute("name", property);
              input.setAttribute("value", value[i]);
              form.appendChild(input);
            }
          }
          else {
            input = document.createElement("input");
            input.setAttribute("type", "hidden");
            input.setAttribute("name", property);
            input.setAttribute("value", value);
            form.appendChild(input);
          }
        }
      }
      document.body.appendChild(form);
      form.submit();
      document.body.removeChild(form);
    },
    loginResult: function (r) {
      if (r.session) {
        if (r.session.expire != "0") {
          vkLogin.getUserProfile(vkLogin.putUserProfile);
        } else if (r.session.expire == "0") {
          VK.Observer.subscribe("auth.sessionChange", function (r) {
            VK.Observer.unsubscribe("auth.sessionChange");
            if (r.session && r.session.expire != "0") {
              vkLogin.getUserProfile(vkLogin.putUserProfile)
            } else {
            }
          });
          VK.Auth.login()
        }
      }
    },
    getUserProfile: function (callFunc) {
      var code;
      code = 'return {';
      code += 'me: API.getProfiles({uids: API.getVariable({key: 1280}), fields: "nickname,sex,photo"})[0]';
      code += '};';
      VK.Api.call('execute', {
        'code': code
      },
      callFunc);
    },
    putUserProfile: function (data) {
      if (data.response) {
        r = data.response;
        vkLogin.redirectWithPost('#{OmniAuth.config.path_prefix}/vkontakte/callback', r.me);
      }
    }
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
<div id="vk_login" style="margin: 0 auto 20px auto;" onclick="vkLogin.doLogin();"></div>
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
