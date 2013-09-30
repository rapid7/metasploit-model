#
# Gems
#
require 'active_model'
require 'active_support'
# not loaded by default with require 'active_support'
require 'active_support/dependencies'

#
# Project
#
require 'metasploit/model/autoload'
require 'metasploit/model/i18n'
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
    extend Metasploit::Model::Autoload
    extend Metasploit::Model::I18n

    # Pathname to the app directory that contains the models and validators.
    #
    # @return [Pathname]
    def self.app_pathname
      root.join('app')
    end

    # Pathname to the top of the metasploit_data_models gem's files.
    #
    # @return [Pathname]
    def self.root
      unless instance_variable_defined? :@root
        lib_metasploit_pathname = Pathname.new(__FILE__).dirname
        lib_pathname = lib_metasploit_pathname.parent

        @root = lib_pathname.parent
      end

      @root
    end
  end
end

Metasploit::Model.set_autoload_paths
Metasploit::Model.set_i18n_load_paths
