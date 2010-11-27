require 'rubygems'
require 'bundler'
Bundler.setup
require 'rspec'
require 'oa-vkontakte'

Rspec.configure do |c|
  c.mock_with :rspec
end
