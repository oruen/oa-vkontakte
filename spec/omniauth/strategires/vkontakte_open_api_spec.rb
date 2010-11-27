require File.dirname(__FILE__) + '/../../spec_helper'

describe OmniAuth::Strategies::VkontakteOpenApi, :type => :strategy do

  include OmniAuth::Test::StrategyTestCase

  def strategy
    [OmniAuth::Strategies::VkontakteOpenApi, 1983892, 'top_secret']
  end

  describe 'POST /auth/vkontakte_open_api/callback с логином и паролем' do
    context "успешный запрос" do
      before(:each) do
        strategy = nil
        post '/auth/vkontakte/callback', {
          'nickname' => 'oruen',
          'first_name' => 'Nick',
          'last_name' => 'Recobra',
          'photo' => 'http://cs191.vkontakte.ru/u00001/e_375bc433.jpg',
          'uid' => '1234567890'
        }
      end

      it "должен устанавливаться защищенный ключ" do
        OmniAuth.config.vkontakte_app_key.should == 'top_secret'
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
