Gem::Specification.new do |spec|
  spec.name = "kramdown-components"
  spec.version = "0.0.1"
  spec.platform = Gem::Platform::RUBY
  spec.summary = ""
  spec.description = ""
  spec.authors = ["Mark Rickerby"]
  spec.email = "me@maetl.net"
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.add_runtime_dependency "kramdown", '~> 2.4.0'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  #spec.add_development_dependency "rspec-html"
  spec.homepage = "http://rubygemspec.org/gems/kramdown-components"
  spec.license = "MIT"
end
