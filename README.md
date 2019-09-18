# HashMath

[![Gem Version](https://badge.fury.io/rb/hash_math.svg)](https://badge.fury.io/rb/hash_math) [![Build Status](https://travis-ci.org/bluemarblepayroll/hash_math.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/hash_math) [![Maintainability](https://api.codeclimate.com/v1/badges/9f9a504b3f5df199a253/maintainability)](https://codeclimate.com/github/bluemarblepayroll/hash_math/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/9f9a504b3f5df199a253/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/hash_math/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Ruby's Hash data structure is ubiquitous and highly flexible.  This library contains common Hash patterns widely used within our code-base:

* Matrix: build a hash up then expand into hash products
* Record: define a list of keys and a base value (for each key) to use as a blueprint for hashes
* Table: key-value pair builder for constructing a two-dimensional array (rows by fields)

See examples for more information on each data structure.

## Installation

To install through Rubygems:

````bash
gem install install hash_math
````

You can also add this to your Gemfile:

````bash
bundle add hash_math
````

## Examples

### Matrix: The Hash Combination Calculator

HashMath::Matrix is a key-value builder that outputs all the different hash combinations.

Say we have this type of matrix:

````ruby
{
  a: [1,2,3],
  b: [4,5,6],
  c: [7,8,9]
}
````

We could code this as:

````ruby
matrix = HashMath::Matrix.new
matrix.add_each(:a, [1,2,3])
matrix.add_each(:b, [4,5,6])
matrix.add_each(:c, [7,8,9])
````

Note: you can also call `Matrix#add` to only add a single value instead of add_each.

and get the combinations by calling to_a:

````ruby
combinations = matrix.to_a
````

which would yield the following hashes:

````ruby
[
  { a: 1, b: 4, c: 7 },
  { a: 1, b: 4, c: 8 },
  { a: 1, b: 4, c: 9 },
  { a: 1, b: 5, c: 7 },
  { a: 1, b: 5, c: 8 },
  { a: 1, b: 5, c: 9 },
  { a: 1, b: 6, c: 7 },
  { a: 1, b: 6, c: 8 },
  { a: 1, b: 6, c: 9 },

  { a: 2, b: 4, c: 7 },
  { a: 2, b: 4, c: 8 },
  { a: 2, b: 4, c: 9 },
  { a: 2, b: 5, c: 7 },
  { a: 2, b: 5, c: 8 },
  { a: 2, b: 5, c: 9 },
  { a: 2, b: 6, c: 7 },
  { a: 2, b: 6, c: 8 },
  { a: 2, b: 6, c: 9 },

  { a: 3, b: 4, c: 7 },
  { a: 3, b: 4, c: 8 },
  { a: 3, b: 4, c: 9 },
  { a: 3, b: 5, c: 7 },
  { a: 3, b: 5, c: 8 },
  { a: 3, b: 5, c: 9 },
  { a: 3, b: 6, c: 7 },
  { a: 3, b: 6, c: 8 },
  { a: 3, b: 6, c: 9 },
]
````

Notes:

* Matrix implements Ruby's Enumerable, which means you have the ability to iterate over each hash combination like you would any other Enumerable object.
* Values can be arrays and it still works.  For example, `#add` (singular form) will honor the array data type: `matrix.add(:a, [1,2,3])` is **not** the same as: `matrix.add_each(:a, [1,2,3])` but it **is** the same as: `matrix.add(:a, [[1,2,3]])`
* Keys are type-sensitive and work just like Hash keys work.

### Record: The Hash Prototype

HashMath::Record generates a prototype hash and ensures all derived hashes conform to its shape.

Say we have a person hash, for example:

````ruby
{
  id: 1,
  name: 'Matt',
  location: 'Chicago'
}
````

we could create a record modeling this:

````ruby
record = HashMath::Record.new(%i[id name location], 'UNKNOWN')
````

Then, we could shape all other hashes using it to ensure each key is populated.  If a key is not populated, the base value will be used ('UNKNOWN' in our case.)  For example:

````ruby
records = [
  record.make(id: 1, name: 'Matt', location: 'Chicago', dob: nil),
  record.make(id: 2, age: 24),
  record.make(id: 3, location: 'Los Angeles')
]
````

Note: The keys `dob` and `age` appeared in the input but will be ignored as they do not conform to the Record.  You could make this strict and raise an error by calling `#make!` instead of `#make`.

our `records` would now equate to:

````ruby
[
  { id: 1, name: 'Matt', location: 'Chicago' },
  { id: 2, name: 'UNKNOWN', location: 'UNKNOWN' },
  { id: 3, name: 'UNKNOWN', location: 'Los Angeles' },
]
````

Notes:

* keys are type-sensitive and works just like Hash keys work.

### Table: The Double Hash (Hash of Hashes)

HashMath::Table builds on top of HashMath::Record.  It constructs a table data-structure using a key-value pair builder method: `#add(row_id, field_id, value)`.  It ultimately outputs an array of Row objects where each Row object has a row_id and fields (field_id => value) hash.  The value proposition here is you can iterate over a key-value pair and construct each row any way you wish.

Building on our Record example above:

````ruby
record = HashMath::Record.new(%i[name location], 'UNKNOWN')

table = HashMath::Table.new(record)
                       .add(1, :name, 'Matt')
                       .add(1, :location, 'Chicago')
                       .add(2, :name, 'Nick')
                       .add(3, :location, 'Los Angeles')
                       .add(2, :name 'Nicholas') # notice the secondary call to "2, :name"

rows = table.to_a
````

which would set our variable `rows` to:

````ruby
[
  HashMath::Row.new(1, { name: 'Matt', location: 'Chicago' }),
  HashMath::Row.new(2, { name: 'Nicholas', location: 'UNKNOWN' }),
  HashMath::Row.new(3, { name: 'UNKNOWN', location: 'Los Angeles' })
]
````

Notes:

* `#add` will throw a KeyOutOfBoundsError if the key is not found.
* key is type-sensitive and works just like Hash keys work.

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
