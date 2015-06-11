# FuzzyWhere

An `ActiveRecord` implementation of [SQLf](http://en.wikipedia.org/wiki/SQLf).
At this moment it allows you to load fuzzy definitions from a yaml file and use then as where conditions.
This is a work in progress and plan to add more ways to create fuzzy predicates and is expected a full implementation of SQLf.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fuzzy_where'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fuzzy_where

Generate configuration files:

    $ rails g fuzzy_where:config

## Usage

Add your definitions to `config/fuzzy_predicates.yml`.
Example:
```yaml
young:
  min: 10
  core1: 15
  core2: 20
  max: 25
```

Then you can use your definitions as follow:
```ruby
    Person.fuzzy_where(age: :young)
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/koombea/fuzzy-record/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License. Copyright 2015 Koombea. http://koombea.com
