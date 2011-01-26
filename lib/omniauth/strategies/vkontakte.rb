require 'omniauth/vkontakte'
require 'omniauth/strategies/vkontakte/view_helper'

module OmniAuth
  class Configuration
    attr_accessor :vkontakte_app_id
    attr_accessor :vkontakte_app_key
  end
end

module OmniAuth
  module Strategies
    class Vkontakte
      include OmniAuth::Strategy
      include ViewHelper::PageHelper

      def initialize(app, app_id, app_key, options = {})
        @options = options
        OmniAuth.config.vkontakte_app_id = app_id
        OmniAuth.config.vkontakte_app_key = app_key
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
        puts Digest::MD5.new.hexdigest(args.sort.join('') + OmniAuth.config.vkontakte_app_key)
        puts sig
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
