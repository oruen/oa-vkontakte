require 'omniauth/vkontakte'
require 'omniauth/strategies/vkontakte_open_api/view_helper'

module OmniAuth
  class Configuration
    attr_accessor :vkontakte_app_id
  end
end

module OmniAuth
  module Strategies
    class VkontakteOpenApi
      include OmniAuth::Strategy
      include ViewHelper::PageHelper

      def initialize(app, app_id, options = {})
        @options = options
        OmniAuth.config.vkontakte_app_id = app_id
        super(app, :vkontakte)
      end

      attr_reader :app_id
      
      def request_phase
        Rack::Response.new(vkontakte_login_button).finish
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => request[:uid],
          'user_info' => {
            'nickname' => request[:nickname],
            'name' => "#{request[:first_name]} #{request[:last_name]}",
            'first_name' => request[:first_name],
            'last_name' => request[:last_name],
            'image' => request[:photo],
            'urls' => { 'Page' => 'http://vkontakte.ru/id' + request[:uid] }
          }
        })
      end
    end
  end
end
