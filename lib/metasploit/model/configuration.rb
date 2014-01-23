# @note This can't be a model in app/models because it is used to setup the autoload_path to app/models.
#
# Configuration for a gem's autoload and i18n load paths that works outside of the railties or rails engines systems.
class Metasploit::Model::Configuration
  # no autoload paths yet, so have to explicitly require
  require 'metasploit/model/configuration/parent'
  extend Metasploit::Model::Configuration::Parent

  #
  # Attributes
  #

  # @!attribute [rw] root
  #   The root of the gem.  All relative paths are resolved relative to {#root}.
  #
  #   @return [Pathname]

  #
  # Children
  #

  # @!macro [attach] child
  #   @!attribute [rw] $1_class
  #     The `Class` used to create {#$1}.
  #
  #     @return [Class]
  #
  #   @!method $1
  #     The $1 configuration.
  #
  #     @return [Object] an instance of {#$1_class}
  #
  #   @!method $1_class
  #     The `Class` used to create {#$1}.
  #
  #     @return [Class]
  child :autoload
  child :i18n

  #
  # Methods
  #

  # The root of the gem.
  #
  # @return [Pathname] root of gem
  # @raise [Metasploit::Model::Configuration::Error] if {#root=} is not called prior to calling {#root}.
  def root
    unless instance_variable_defined?(:@root)
      raise Metasploit::Model::Configuration::Error, "#{self.class}.root not set prior to use"
    end

    @root
  end

  # Sets root of this gem.
  #
  # @param root [Pathname, String]
  # @return [String]
  def root=(root)
    @root = Pathname.new root
  end

  # Sets up {#autoload} and {#i18n}
  #
  # @return [void]
  # @raise [Metasploit::Model::Invalid] if {#configuration} {Metasploit::Model::Configuration#root} is not set.
  def setup
    autoload.setup
    i18n.setup
  end
end