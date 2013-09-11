module Metasploit
  module Model
    # Defines methods for adding paths to `ActiveSupport::Dependencies.autoload_paths`.
    module Autoload
      # Combines {#autoload_once_paths} and {#autoload_paths} as both need to be added to
      # `ActiveSupport::Dependencies.autoload_paths`.
      #
      # @return [Array<String>]
      def all_autoload_paths
        @all_autoload_paths ||= (autoload_once_paths + autoload_paths).uniq
      end

      # {#relative_autoload_once_paths} converted to absolute paths.
      #
      # @return [Array<String>]
      def autoload_once_paths
        @autoload_once_paths ||= relative_autoload_once_paths.collect { |relative_autoload_path|
          root.join(relative_autoload_path).to_path
        }
      end

      # {#relative_autoload_paths} converted to absolute paths.
      #
      # @return [Array<String>]
      def autoload_paths
        @autoload_paths ||= relative_autoload_paths.collect { |relative_autoload_path|
          root.join(relative_autoload_path).to_path
        }
      end

      # Paths relative {Metasploit::Model.root} that are to be added to `ActiveSupport::Dependencies.autoload_paths` and
      # `ActiveSupport::Dependencies.autoload_once_paths`.
      def relative_autoload_once_paths
        @relative_autoload_once_paths ||= [
            'lib'
        ]
      end

      # Paths relative to {Metasploit::Model.root} that are to be added to `ActiveSupport::Dependencies.autoload_paths`,
      # but not `ActiveSupport::Dependencies.autoload_once_paths`
      #
      # @return [Array<String>]
      def relative_autoload_paths
        @relative_autoload_paths ||= [
            File.join('app', 'models'),
            File.join('app', 'validators')
        ]
      end

      # Adds {#autoload_paths} to `ActiveSupport::Dependencies.autoload_paths` if they are not already there.
      #
      # @return [void]
      def set_autoload_paths
        all_autoload_paths.each do |autoload_path|
          unless ActiveSupport::Dependencies.autoload_paths.include? autoload_path
            ActiveSupport::Dependencies.autoload_paths << autoload_path
          end
        end

        autoload_once_paths.each do |autoload_once_path|
          unless ActiveSupport::Dependencies.autoload_once_paths.include? autoload_once_path
            ActiveSupport::Dependencies.autoload_once_paths << autoload_once_path
          end
        end
      end
    end
  end
end