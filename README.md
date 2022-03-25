# Metasploit::Model [![Build Status](https://github.com/rapid7/metasploit-model/actions/workflows/verify.yml/badge.svg)](https://github.com/rapid7/metasploit-model/actions/workflows/verify.yml)[![Code Climate](https://codeclimate.com/github/rapid7/metasploit-model.png)](https://codeclimate.com/github/rapid7/metasploit-model)[![Dependency Status](https://gemnasium.com/rapid7/metasploit-model.svg)](https://gemnasium.com/rapid7/metasploit-model)[![Gem Version](https://badge.fury.io/rb/metasploit-model.svg)](http://badge.fury.io/rb/metasploit-model)[![Inline docs](http://inch-ci.org/github/rapid7/metasploit-model.svg?branch=master)](http://inch-ci.org/github/rapid7/metasploit-model)[![PullReview stats](https://www.pullreview.com/github/rapid7/metasploit-model/badges/master.svg)](https://www.pullreview.com/github/rapid7/metasploit-model/reviews/master)

## Versioning

`Metasploit::Model` is versioned using [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html).  Each branch should set `Metasploit::Model::Version::PRERELEASE` to the branch SUMMARY, while master should have no `PRERELEASE` and the `PRERELEASE` section of `Metasploit::Model::VERSION` does not exist.

## Installation

Add this line to your application's Gemfile:

    gem 'metasploit-model'

And then execute:

    $ bundle
    
**This gem's `Rails::Engine` is not required automatically.** You'll need to also add the following to your `config/application.rb`:

    require 'metasploit/model/engine'

Or install it yourself as:

    $ gem install metasploit-model

## Running tests

Copy the database configuration and modify as appropriate:

```
cp spec/dummy/config/database.yml.github_actions spec/dummy/config/database.yml
```

Set up the database:

```
bundle exec rake db:test:prepare
bundle exec rake db:migrate RAILS_ENV=test
```

Run the test suite:

```
bundle exec rspec
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)
