# Benchmark::Perf

[![Gem Version](https://badge.fury.io/rb/benchmark-perf.svg)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/benchmark-perf.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/benchmark-perf/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/benchmark-perf/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/peter-murach/benchmark-perf.svg?branch=master)][inchpages]

[gem]: http://badge.fury.io/rb/benchmark-perf
[travis]: http://travis-ci.org/peter-murach/benchmark-perf
[codeclimate]: https://codeclimate.com/github/peter-murach/benchmark-perf
[coverage]: https://coveralls.io/r/peter-murach/benchmark-perf
[inchpages]: http://inch-ci.org/github/peter-murach/benchmark-perf

> Measure execution time and iterations per second.

The **Benchmark::Perf** is used by [rspec-benchmark](https://github.com/peter-murach/rspec-benchmark)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'benchmark-perf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install benchmark-perf

## Usage

To see how long it takes to execute code do:

```ruby
bench = Benchmark::Perf::ExecutionTime.new
mean, stddev = bench.run(10) { ... }
```

In order to check how many iterations per second a given code takes do:

```ruby
bench = Benchmark::Perf::Iteration.new
mean, stddev, iter, elapsed_time = bench.run { ... }
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/benchmark-perf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2016 Piotr Murach. See LICENSE for further details.
