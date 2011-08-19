# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo-logger/version"

Gem::Specification.new do |s|
  s.name        = "mongo-logger"
  s.version     = MongoLogger::VERSION
  s.authors     = ["Josh Moore"]
  s.email       = ["joshsmoore@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "mongo-logger"
  
  s.add_dependency 'mongo'
  s.add_dependency 'bson_ext'
  s.add_dependency 'SystemTimer'

  s.add_development_dependency 'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
