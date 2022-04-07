source 'https://rubygems.org'

# Specify your gem's dependencies in metasploit-model.gemspec
gemspec

group :development do
  gem 'pry-byebug'
end

# used by dummy application
group :development, :test do
  # supplies factories for producing model instance for specs
  # Version 4.1.0 or newer is needed to support generate calls without the 'FactoryGirl.' in factory definitions syntax.
  gem 'factory_bot'
  # auto-load factories from spec/factories
  gem 'factory_bot_rails'
end

group :test do
  # rails is not used because activerecord should not be included, but rails would normally coordinate the versions
  # between its dependencies, which is now handled by this constraint.

  # Dummy app uses actionpack for ActionController, but not rails since it doesn't use activerecord.
  gem 'actionpack'
  # Engine tasks are loaded using railtie
  gem 'railties'
  gem 'rspec-rails'
  # Used for Postgres
  gem 'pg'
  # provides a complete suite of testing facilities supporting TDD, BDD, mocking, and benchmarking.
  gem "minitest"
  # In a full rails project, factory_girl_rails would be in both the :development, and :test group, but since we only
  # want rails in :test, factory_girl_rails must also only be in :test.
  # add matchers from shoulda, such as validates_presence_of, which are useful for testing validations
  gem 'shoulda-matchers'
  # code coverage of tests
  gem 'simplecov', :require => false
  # defines time zones for activesupport.  Must be explicit since it is normally implicit with activerecord
  gem 'tzinfo'
end
