require 'rails'

module Metasploit
  module Model
    # Rails engine for Metasploit::Model.  Will automatically be used if `Rails` is defined when
    # 'metasploit/model' is required, as should be the case in any normal Rails application Gemfile where
    # gem 'rails' is the first gem in the Gemfile.
    class Engine < Rails::Engine
      # @see http://viget.com/extend/rails-engine-testing-with-rspec-capybara-and-factorygirl
      config.generators do |g|
        g.assets false
        g.helper false
        g.test_framework :rspec, :fixture => false
      end
    end
  end
end
