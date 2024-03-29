require "kramdown-components"

Gem::Specification.new do |spec|
  spec.name = "kramdown-components"
  spec.version = "0.3.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "Rewrite and capture sections of Markdown documents using HTML Custom Elements."
  spec.description = "Mix and match HTML and Markdown syntax. Generate nested DOM trees from a single top level element. Extract content from custom elements."
  spec.authors = ["Mark Rickerby"]
  spec.email = "me@maetl.net"
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.add_runtime_dependency "kramdown", "~> 2.4.0"
  spec.add_development_dependency "bundler", "~> 2.3.22"
  spec.add_development_dependency "rspec", "~> 3.11.0"
  spec.homepage = "https://github.com/maetl/kramdown-components"
  spec.license = "MIT"
end
