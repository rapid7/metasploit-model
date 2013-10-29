# Allows modules to be configured (using {Metasploit::Model::Configuration}) similar to Rails engines.
#
# @example Making gem module configurable
#   module MyGem
#     extend Metasploit::Model::Configured
#
#     # assumes __FILE__ is lib/my_gem.rb
#     lib_my_gem_pathname = Pathname.new(___FILE__)
#     lib_pathname = lib_my_gem_pathname.parent
#     configuration.root = lib_pathname.parent
#
#     configuration.autoload.paths << 'app/models'
#   end
#
#   # registers 'app/models' as an autoload_path with ActiveSupport::Dependencies
#   MyGem.setup
module Metasploit::Model::Configured
  def configuration
    unless instance_variable_defined? :@configuration
      require 'metasploit/model/configuration'

      @configuration = Metasploit::Model::Configuration.new
    end

    @configuration
  end

  # @!method root
  #   The configured root.
  #
  #   @return (see Metasploit::Model::Configuration#root)
  #
  # @!method setup
  #   Sets up the autoload and i18n paths for the configured gem.
  #
  #   @return (see Metasploit::Model::Configuration.setup)
  #   @raise (see Metasploit::Model::Configuration.setup)
  delegate :root,
           :setup,
           to: :configuration
end
