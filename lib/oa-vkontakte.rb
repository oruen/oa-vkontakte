require 'omniauth/vkontakte'
if defined?(Rails)
  ActionController::Base.helper OmniAuth::Strategies::VkontakteOpenApi::ViewHelper::PageHelper
end
