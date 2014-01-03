require 'metasploit/model/configuration/child'

# Defines methods for adding paths to `ActiveSupport::Dependencies.autoload_paths`.
class Metasploit::Model::Configuration::Autoload < Metasploit::Model::Configuration::Child
  #
  # Attributes
  #

  # @!attribute [rw] relative_once_paths
  #   Paths relative to {Metasploit::Model::Configuration::Child#configuration #configuration}
  #   {Metasploit::Model::Configuration#root #root} that should only be autoloaded once.
  #
  #   @return [Array<String>]

  # @!attribute [rw] relative_paths
  #   Paths relative to {Metasploit::Model::Configuration::Child#configuration #configuration}
  #   {Metasploit::Model::Configuration#root #root} that should be autoloaded more than once.
  #
  #   @return [Array<String>]

  #
  # Methods
  #

  # Combines {#once_paths} and {#paths} as both need to be added to
  # `ActiveSupport::Dependencies.autoload_paths`.
  #
  # @return [Array<String>]
  def all_paths
    @all_paths ||= (once_paths + paths).uniq
  end

  def eager_load!
    # sort to favor app over lib since it is assumed that app/models will define classes and lib will define modules
    # included in those classes that are defined under the class namespaces, so the class needs to be required first
    all_paths.sort.each do |load_path|
      matcher = /\A#{Regexp.escape(load_path)}\/(.*)\.rb\Z/

      Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
        require_dependency file.sub(matcher, '\1')
      end
    end
  end

  # {#relative_once_paths} converted to absolute paths.
  #
  # @return [Array<String>]
  def once_paths
    @once_paths ||= relative_once_paths.collect { |relative_path|
      configuration.root.join(relative_path).to_path
    }
  end

  # {#relative_paths} converted to absolute paths.
  #
  # @return [Array<String>]
  def paths
    @paths ||= relative_paths.collect { |relative_path|
      configuration.root.join(relative_path).to_path
    }
  end

  # Paths relative to {Metasploit::Model::Configuration#root} that are to be added to
  # `ActiveSupport::Dependencies.autoload_paths` and `ActiveSupport::Dependencies.autoload_once_paths`.
  #
  # @return [Array<String>] Defaults to ['lib']
  def relative_once_paths
    @relative_once_paths ||= [
        'lib'
    ]
  end

  attr_writer :relative_once_paths

  # Paths relative to {Metasploit::Model::Configuration#root} that are to be added to
  # `ActiveSupport::Dependencies.autoload_paths`, but not `ActiveSupport::Dependencies.autoload_once_paths`
  #
  # @return [Array<String>] Defaults to ['app/models']
  def relative_paths
    @relative_paths ||= [
        File.join('app', 'models')
    ]
  end

  attr_writer :relative_paths

  # Adds {#all_paths} to `ActiveSupport::Dependencies.autoload_paths` if they are not already there and adds
  # {#once_paths} to `ActiveSupport::Dependencies.autoload_once_paths` if they are not already there.
  #
  # @return [void]
  def setup
    all_paths.each do |autoload_path|
      unless ActiveSupport::Dependencies.autoload_paths.include? autoload_path
        ActiveSupport::Dependencies.autoload_paths << autoload_path
      end
    end

    once_paths.each do |autoload_once_path|
      unless ActiveSupport::Dependencies.autoload_once_paths.include? autoload_once_path
        ActiveSupport::Dependencies.autoload_once_paths << autoload_once_path
      end
    end
  end
end
