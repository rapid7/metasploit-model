source 'https://rubygems.org'

# Specify your gem's dependencies in metasploit-model.gemspec
gemspec

group :development do
  gem 'pry-byebug'
end

# used by dummy application
group :development, :test do
  # Temporary, remove once the Rails 7.1 update is complete
  # see: https://stackoverflow.com/questions/79360526/uninitialized-constant-activesupportloggerthreadsafelevellogger-nameerror
  gem 'concurrent-ruby', '1.3.4'
  # supplies factories for producing model instance for specs
  # Version 4.1.0 or newer is needed to support generate calls without the 'FactoryGirl.' in factory definitions syntax.
  gem 'factory_bot'
  # auto-load factories from spec/factories
  gem 'factory_bot_rails'
end

group :test do
  # Rails components required by the dummy application.
  gem 'actionpack'
  gem 'activerecord'
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
  # defines time zones for activesupport.
  gem 'tzinfo'
end
