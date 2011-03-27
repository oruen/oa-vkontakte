require 'omniauth/vkontakte'
require 'omniauth/strategies/vkontakte/view_helper'

module OmniAuth
  class Configuration
    attr_accessor :vkontakte_app_id
    attr_accessor :vkontakte_app_key
    attr_accessor :vkontakte_params
  end
end

module OmniAuth
  module Strategies
    class Vkontakte
      include OmniAuth::Strategy
      include ViewHelper::PageHelper

      # Про права приложения можно узнать здесь: http://vkontakte.ru/developers.php?o=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0+%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
      def initialize(app, app_id, app_key, params = {:permissions => '1'})
        OmniAuth.config.vkontakte_app_id = app_id
        OmniAuth.config.vkontakte_app_key = app_key
        OmniAuth.config.vkontakte_params = params
        super(app, :vkontakte)
      end

      attr_reader :app_id
      
      def request_phase
        Rack::Response.new(vkontakte_login_page).finish
      end

      def callback_phase
        app_cookie = request.cookies["vk_app_#{OmniAuth.config.vkontakte_app_id}"]
        return fail!(:invalid_credentials) unless app_cookie
        args = app_cookie.split("&")
        sig_index = args.index { |arg| arg =~ /^sig=/ }
        return fail!(:invalid_credentials) unless sig_index
        sig = args.delete_at(sig_index)
        return fail!(:invalid_credentials) unless Digest::MD5.new.hexdigest(args.sort.join('') + OmniAuth.config.vkontakte_app_key) == sig[4..-1]
        super
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
