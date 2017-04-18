# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jwtgen/version'

Gem::Specification.new do |spec|
  spec.name          = 'jwtgen'
  spec.version       = Jwtgen::VERSION
  spec.authors       = ['Oleksandr Avoyants']
  spec.email         = ['shhavel@gmail.com']

  spec.summary       = %q{CLI for generating Json Web Tokens (JWT's)}
  spec.description   = <<-EOF
CLI for generating Json Web Tokens (JWT's).
CLI takes multiple key value pairs as input, and copy the generated JWT to your clipboard.
Required inputs are user_id and email. In addition, other key/value pairs can also be entered.
  EOF
  spec.homepage      = 'https://github.com/shhavel/jwtgen'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'aruba', '~> 0.14.2'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'jwt'
  spec.add_dependency 'clipboard'
end
