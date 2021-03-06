# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem-miner/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem-miner'
  spec.version       = GemMiner::VERSION
  spec.authors       = ['Reevoo']
  spec.email         = ['developers@reevoo.com']

  spec.summary       = %q{Collect Gemfiles and Gemspecs from multiple repositories.}
  spec.homepage      = 'https://github.com/reevoo/gem-miner'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # GitHub API Client
  spec.add_dependency 'octokit', '~> 4'
  
  # Gem installation magic
  spec.add_dependency 'bundler', '~> 1'

  # CLI helper. Not at v1 yet...
  spec.add_dependency 'thor'

  # Dev dependencies
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'pry-byebug'
end
