#
# Gems
#
require 'active_support/dependencies'

#
# Project
#
require 'metasploit/model/validators'
require 'metasploit/model/version'

# Only include the Rails engine when using Rails.  This allows the non-Rails projects, like metasploit-framework to use
# the validators by calling Metasploit::Model.require_validators.
if defined? Rails
  require 'metasploit/model/engine'
end

module Metasploit
  module Model
    extend Metasploit::Model::Validators

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

lib_pathname = Metasploit::Model.root.join('lib')
lib_path = lib_pathname.to_path
# Add path to gem's lib so that concerns for models are loaded correctly if models are reloaded
ActiveSupport::Dependencies.autoload_paths << lib_path
ActiveSupport::Dependencies.autoload_once_paths << lib_path