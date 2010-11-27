require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'rake/contrib/sshpublisher'
RSpec::Core::RakeTask.new(:spec) do |t|
end
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new do |t|
end
