#
# Gems
#
# gems must load explicitly any gem declared in gemspec
# @see https://github.com/bundler/bundler/issues/2018#issuecomment-6819359
#
#

require 'active_model'
require 'active_support'
# not loaded by default with require 'active_support'
require 'active_support/dependencies'
# Protect attributes from mass-assignment in ActiveRecord models.
require 'protected_attributes'

#
# Project
#
require 'metasploit/model/version'

# Only include the Rails engine when using Rails.  This allows the non-Rails projects, like metasploit-framework to use
# the validators by calling Metasploit::Model.require_validators.
if defined? Rails
  require 'metasploit/model/engine'
end

# Top-level namespace shared between metasploit-model, metasploit-framework, and Pro.
module Metasploit
  # The namespace for this gem.  All code under the {Metasploit::Model} namespace is code that is shared between
  # in-memory ActiveModels in metasploit-framework and database ActiveRecords in metasploit_data_models.  Having a
  # separate gem for this shard code outside of metasploit_data_models is necessary as metasploit_data_models is an
  # optional dependency for metasploit-framework as metasploit-framework can work without a database.
  module Model
    require 'metasploit/model/configured'
    extend Metasploit::Model::Configured

    lib_metasploit_pathname = Pathname.new(__FILE__).dirname
    lib_pathname = lib_metasploit_pathname.parent
    configuration.root = lib_pathname.parent

    configuration.autoload.relative_paths << File.join('app', 'validators')
  end
end

Metasploit::Model.setup
