# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'k_means_pp/version'

Gem::Specification.new do |spec|
  spec.name          = 'k_means_pp'
  spec.version       = KMeansPP::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']

  spec.summary       = 'K-means++ Algorithm Implementation.'
  spec.description   = 'This is a Ruby implementation of the k-means++ ' \
                       'algorithm for data clustering. In other words: ' \
                       'Grouping a bunch of X, Y points into K groups.'
  spec.homepage      = 'https://github.com/ollie/k_means_pp'
  spec.license       = 'MIT'

  # rubocop:disable Metrics/LineLength
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.10'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.10'

  # Code style, debugging, docs
  spec.add_development_dependency 'rubocop',    '~> 0.35'
  spec.add_development_dependency 'pry',        '~> 0.10'
  spec.add_development_dependency 'yard',       '~> 0.8'
  spec.add_development_dependency 'rake',       '~> 10.4'
  # spec.add_development_dependency 'pry-byebug', '~> 3.3'
  # spec.add_development_dependency 'ruby-prof',  '~> 0.15'
  # spec.add_development_dependency 'gnuplot',    '~> 2.6'
end
