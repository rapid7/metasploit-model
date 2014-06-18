require 'metasploit/model/configuration/child'

# Defines methods for adding paths to `I18n.load_path`
class Metasploit::Model::Configuration::I18n < Metasploit::Model::Configuration::Child
  #
  # Attributes
  #

  # @!attribute [rw] relative_directories
  #   Paths relative to root that point to directories that contain locale files like `en.yml`.
  #
  #   @return [Array<String>] Defaults to ['config/locales']

  # Absolute paths to directories under which to find I18n .yml files.
  #
  # @return [Array<String>]
  def directories
    @directories ||= relative_directories.collect { |relative_path|
      configuration.root.join(relative_path).to_path
    }
  end

  # Absolute paths to I18n .yml files.
  #
  # @return [Array<String>]
  def paths
    @paths ||= directories.flat_map { |directory|
      glob = File.join(directory, '*.yml')
      Dir.glob(glob)
    }
  end

  # Relative paths to I18n directories.
  #
  # @return [Array<String>] Defaults to 'config/locales'
  def relative_directories
    @relative_directories ||= [
        File.join('config', 'locales')
    ]
  end

  attr_writer :relative_directories

  # Adds {#paths} to `I18n.load_path` if they are not already there.
  #
  # @return [void]
  def setup
    paths.each do |path|
      unless ::I18n.load_path.include? path
        ::I18n.load_path << path
      end
    end
  end
end
