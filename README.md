# TAPI

TAPI is an API testing framework with document generation and code/spec generation.
TAPI provides a DSL for you to describe your API and the tests that need to be
executed, and can then run the tests, export to openapi 3.0 format.

TAPI can also generate a single binary that runs all the tests in the suite
so you can easily run a contained test thet runs on CI.

## tapi init

  set up the directory structure with sample data
  Gemfile
  env.rb
  api/
  schema/

## tapi

  run tapi in the current dir with the default env
  this executes all the requests, validates the output
  and generates a pretty output showing test result status
  specify different envs with `-env staging`

## tapi doc

  generate documentation

## tapi spec

  allow for different output formatters, default openapi 3.0

## tapi gen

  generate a runnable test suite for use on CI
  allow for different output generators, default to go

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tapi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
