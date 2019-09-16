# HashMath

[![Gem Version](https://badge.fury.io/rb/hash_math.svg)](https://badge.fury.io/rb/hash_math) [![Build Status](https://travis-ci.org/bluemarblepayroll/hash_math.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/hash_math) [![Maintainability](https://api.codeclimate.com/v1/badges/9f9a504b3f5df199a253/maintainability)](https://codeclimate.com/github/bluemarblepayroll/hash_math/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/9f9a504b3f5df199a253/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/hash_math/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Ruby's Hash data structure is ubiquitous and highly flexible.  This library contains common Hash patterns widely used within our code-base:

* Matrix: build a hash up then expand into hash products
* Record: define a list of keys and base value to use as a blueprint for hashes
* Table: key-value pair two-dimensional array of hash builder

See examples for more information on each data structure.

## Installation

To install through Rubygems:

````
gem install install hash_math
````

You can also add this to your Gemfile:

````
bundle add hash_math
````

## Examples

### The Matrix Builder

todo

### The Record Maker

todo

### The Table Builder

todo

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check hash_math.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/hash_math.git)
4. Navigate to the root folder (cd hash_math)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite and code-coverage tool, run:

````bash
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````bash
bundle exec guard
````

Also, do not forget to run Rubocop:

````bash
bundle exec rubocop
````

or run all three in one command:

````bash
bundle exec rake
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/hash_math/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/hash_math/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
