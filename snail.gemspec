require File.dirname(__FILE__) + '/lib/snail/version'

Gem::Specification.new do |s|
  s.name              = "snail"
  s.version           = Snail::VERSION
  s.authors           = ['Lance Ivy']
  s.email             = ['lance@cainlevy.net']
  s.summary           = "Easily format snail mail addresses for international delivery"
  s.description       = "International snail mail addressing is a pain. This begins to make it easier."
  s.homepage          = "http://github.com/cainlevy/snail"

  s.files             = `git ls-files`.split($/)
  s.test_files        = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths     = ["lib"]

  s.add_dependency    "activesupport"
end
