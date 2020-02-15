require_relative "lib/benchmark/perf/version"

Gem::Specification.new do |spec|
  spec.name          = "benchmark-perf"
  spec.version       = Benchmark::Perf::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{Execution time and iteration performance benchmarking}
  spec.description   = %q{Execution time and iteration performance benchmarking}

  spec.homepage      = "https://github.com/piotrmurach/benchmark-perf"
  spec.license       = "MIT"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri"   => "https://github.com/piotrmurach/benchmark-perf/issues",
    "changelog_uri"     => "https://github.com/piotrmurach/benchmark-perf/blob/master/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/benchmark-perf",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/piotrmurach/benchmark-perf"
  }

  spec.files            = Dir["lib/**/*", "LICENSE.txt"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md"]
  spec.require_paths    = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"
end
