# FuzzyWhere
[![Build Status](https://travis-ci.org/koombea/fuzzy_where.svg?branch=master)](https://travis-ci.org/koombea/fuzzy_where)
[![Code Climate](https://codeclimate.com/github/koombea/fuzzy_where/badges/gpa.svg)](https://codeclimate.com/github/koombea/fuzzy_where)

An `ActiveRecord` implementation of [SQLf](http://en.wikipedia.org/wiki/SQLf).
At this moment it allows you to load fuzzy definitions from a yaml file and use
them as where conditions. More features from SQLf will be added to this gem in future iterations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fuzzy_where'
```

And then execute:

```console
bundle
```

Or install it yourself as:

```console
gem install fuzzy_where
```

Finally generate the configuration files:

```console
rails g fuzzy_where:config
```

## Usage

Fuzzy predicates are stored in `config/fuzzy_predicates.yml`. You can use a generator to populate this file.

```console
rails generate fuzzy_where:predicate PREDICATE min core1 core2 max
```

Replace PREDICATE with the name you wish to use for you linguistic expression and set the values for the trapezoid function.

### Example:

```console
rails generate fuzzy_where:predicate young 10 15 20 25
```

Will produce:

```yaml
# config/fuzzy_predicates.yml
young:
  min: 10
  core1: 15
  core2: 20
  max: 25
```

Then you can use your definitions as follows:

```ruby
Person.fuzzy_where(age: :young)
```

## Contributing

1. Fork it ( https://github.com/koombea/fuzzy_where/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License. Copyright 2015 Koombea. http://koombea.com
