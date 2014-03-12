$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rops/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rops"
  s.version     = Rops::VERSION
  s.authors     = ["Ryan McGrath"]
  s.email       = ["ryan@madebymany.co.uk"]
  s.homepage    = "https://github.com/madebymany/service_gen"
  s.summary     = "configuration generators"
  s.description = "Collection of configuration generators for common server software"
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "wrong"
  s.add_development_dependency "ansi"
  s.add_development_dependency "turn"
  s.add_development_dependency "pry"
end
