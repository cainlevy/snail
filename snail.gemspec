Gem::Specification.new do |s|
  s.name              = "snail"
  s.version           = "0.5.2"
  s.summary           = "Easily format snail mail addresses for international delivery"
  s.description       = "International snail mail addressing is a pain. This begins to make it easier."
  s.author            = "Lance Ivy"
  s.email             = "lance@cainlevy.net"
  s.homepage          = "http://github.com/cainlevy/snail"
  s.has_rdoc          = true
  s.rdoc_options      << "--title" << "Snail" << "--line-numbers"
  s.files             = Dir.glob("lib/**/*.rb") + Dir.glob("test/**/*.rb") + ["README.rdoc","MIT-LICENSE"]
end
