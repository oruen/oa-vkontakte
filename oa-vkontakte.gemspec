# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "oa-vkontakte/version"

Gem::Specification.new do |s|
  s.name = %q{oa-vkontakte}
  s.version = Oa::Vkontakte::VERSION
  s.authors = ["Nick Recobra"]
  s.summary = %q{OmniAuth extension for vkontakte.ru authentication}
  s.description = %q{OmniAuth extension for vkontakte.ru authentication}
  s.email = %q{oruenu@gmail.com}
  s.homepage = %q{http://github.com/oruen/oa-vkontakte}
  s.rubyforge_project = %q{oa-vkontakte}
  
  s.add_dependency(%q<oa-core>, [">= 0.1.6"])
  s.add_development_dependency(%q<rspec>, ["~> 2.1.0"])
  s.add_development_dependency(%q<yard>, [">= 0"])
  s.add_development_dependency(%q<rack-test>, ["~> 0.5.6"])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

