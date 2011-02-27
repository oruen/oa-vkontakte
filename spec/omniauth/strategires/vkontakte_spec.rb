# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe OmniAuth::Strategies::Vkontakte, :type => :strategy do

  include OmniAuth::Test::StrategyTestCase

  def strategy
    [OmniAuth::Strategies::Vkontakte, 1983892, '6FF1PUlZfEyutJxctvtd']
  end

  describe 'POST /auth/vkontakte_open_api/callback с логином и паролем' do
    before(:each) do
      @params = {
        'nickname' => 'oruen',
        'first_name' => 'Nick',
        'last_name' => 'Recobra',
        'photo' => 'http://cs191.vkontakte.ru/u00001/e_375bc433.jpg',
        'uid' => '1234567890'
      }
    end

    context "неуспешный запрос" do
      it "не должен быть успешным при отсутствии куки vk_app_<APP_ID>" do
        clear_cookies
        post '/auth/vkontakte/callback', @params
        last_response.should_not be_ok
      end

      it "не должен быть успешным при невалидной куке vk_app_<APP_ID>" do
        set_cookie "vk_app_#{OmniAuth.config.vkontakte_app_id}=expire"
        post '/auth/vkontakte/callback', @params
        last_response.should_not be_ok
      end
    end

    context "успешный запрос" do
      before(:each) do
        strategy = nil
        string = "expire=1271238742&mid=100172&secret=97c1e8933e&sid=549b550f608e4a4d247734941debb5e68df50a66c58dc6ee2a4f60a2&sig=372df9795fe8dd29684a2f996872457c"
        set_cookie "vk_app_#{OmniAuth.config.vkontakte_app_id}=#{Rack::Utils::escape string}"
        post '/auth/vkontakte/callback', @params
      end

      it "должен устанавливаться защищенный ключ" do
        OmniAuth.config.vkontakte_app_key.should == '6FF1PUlZfEyutJxctvtd'
      end
  
      
      it 'должен быть успешным' do
        last_response.should be_ok
      end

      sets_an_auth_hash

      sets_provider_to 'vkontakte'

      it 'должен устанавливать параметры' do
        hash = last_request.env['omniauth.auth']
        hash.should == {
          'uid' => '1234567890',
          'provider' => 'vkontakte',
          'user_info' => {
            'name' => 'Nick Recobra',
            'nickname' => 'oruen',
            'first_name' => 'Nick',
            'last_name' => 'Recobra',
            'image' => 'http://cs191.vkontakte.ru/u00001/e_375bc433.jpg',
            'urls' => { 'Page' => 'http://vkontakte.ru/id1234567890' } 
          }
        }
      end
    end
  end
end
