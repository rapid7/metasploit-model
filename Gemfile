source 'https://rubygems.org'

# Specify your gem's dependencies in metasploit-model.gemspec
gemspec

# used by dummy application
group :development, :test do
  # supplies factories for producing model instance for specs
  # Version 4.1.0 or newer is needed to support generate calls without the 'FactoryGirl.' in factory definitions syntax.
  gem 'factory_girl', '>= 4.1.0'
  # auto-load factories from spec/factories
  gem 'factory_girl_rails'
end

group :test do
  # rails is not used because activerecord should not be included, but rails would normally coordinate the versions
  # between its dependencies, which is now handled by this constraint.
  rails_version_constraint = [
      '>= 3.2.0',
      '< 4.0.0'
  ]

  # Dummy app uses actionpack for ActionController, but not rails since it doesn't use activerecord.
  gem 'actionpack', *rails_version_constraint
  # Uploads simplecov reports to coveralls.io
  gem 'coveralls', require: false
  # Engine tasks are loaded using railtie
  gem 'railties', *rails_version_constraint
  gem 'rspec'
  # need rspec-core >= 2.14.0 because 2.14.0 introduced RSpec::Core::SharedExampleGroup::TopLevel
  gem 'rspec-core', '>= 2.14.0'
  # need rspec-rails >= 2.12.0 as 2.12.0 adds support for redefining named subject in nested context that uses the
  # named subject from the outer context without causing a stack overflow.
  gem 'rspec-rails', '>= 2.12.0'
  # In a full rails project, factory_girl_rails would be in both the :development, and :test group, but since we only
  # want rails in :test, factory_girl_rails must also only be in :test.
  # add matchers from shoulda, such as validates_presence_of, which are useful for testing validations
  gem 'shoulda-matchers'
  # code coverage of tests
  gem 'simplecov', :require => false
  # defines time zones for activesupport.  Must be explicit since it is normally implicit with activerecord
  gem 'tzinfo'
end
