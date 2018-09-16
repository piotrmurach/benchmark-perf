lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'benchmark/perf/version'

Gem::Specification.new do |spec|
  spec.name          = "benchmark-perf"
  spec.version       = Benchmark::Perf::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]
  spec.summary       = %q{Execution time and iteration performance benchmarking}
  spec.description   = %q{Execution time and iteration performance benchmarking}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['{lib,spec}/**/*.rb']
  spec.files        += Dir['tasks/*', 'benchmark-perf.gemspec']
  spec.files        += Dir['README.md', 'CHANGELOG.md', 'LICENSE.txt', 'Rakefile']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
