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

require 'metasploit/model/engine'
require 'metasploit/model/version'

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
