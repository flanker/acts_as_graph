lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'acts_as_graph/version'

Gem::Specification.new do |s|
  s.name        = 'acts_as_graph'
  s.version     = ActsAsGraph::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Zhichao Feng']
  s.email       = ['flankerfc@gmail.com']
  s.homepage    = 'https://github.com/flanker'
  s.summary     = 'A very simple acts as graph for your model'
  s.description = 'A very simple acts as graph for your model'
  s.license     = 'MIT'

  s.required_ruby_version     = '>= 2.3'
  s.required_rubygems_version = '>= 1.3.6'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- test/*`.split("\n")
  s.require_path = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'

end
