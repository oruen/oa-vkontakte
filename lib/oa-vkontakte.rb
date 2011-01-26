require 'omniauth/vkontakte'

module Oa
  module Vkontakte
  end
end

if defined?(Rails)
  ActionController::Base.helper OmniAuth::Strategies::Vkontakte::ViewHelper::PageHelper
end
