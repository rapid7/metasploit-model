# @note This can't be a model in app/models because it is used to setup the autoload_path to app/models.
#
# Configuration for a gem's autoload and i18n load paths that works outside of the railties or rails engines systems.
class Metasploit::Model::Configuration
  #
  # Attributes
  #

  # @!attribute [rw] root
  #   The root of the gem.  All relative paths are resolved relative to {#root}.
  #
  #   @return [Pathname]

  #
  # Methods
  #

  # Autoload path configuration.
  #
  # @return [Metasploit::Model::Configuration::Autoload]
  def autoload
    unless instance_variable_defined? :@autoload
      require 'metasploit/model/configuration/autoload'

      autoload = Metasploit::Model::Configuration::Autoload.new
      autoload.configuration = self

      @autoload = autoload
    end

    @autoload
  end

  # Internationalization (I18n) configuration.
  #
  # @return [Metasploit::Model::Configuration::I18n]
  def i18n
    unless instance_variable_defined? :@i18n
      require 'metasploit/model/configuration/i18n'

      i18n = Metasploit::Model::Configuration::I18n.new
      i18n.configuration = self

      @i18n = i18n
    end

    @i18n
  end

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