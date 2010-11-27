require 'rubygems'
require 'bundler'
Bundler.setup
require 'rspec'
require 'omniauth/test'
require 'rack/test'
require 'oa-vkontakte'

Rspec.configure do |c|
  c.mock_with :rspec
  c.include Rack::Test::Methods
  c.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end
