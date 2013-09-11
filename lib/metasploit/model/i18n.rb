module Metasploit
  module Model
    # Defines methods for adding paths to `I18n.load_path`
    module I18n
      # Absolute paths to directories under which to find I18n .yml files.
      #
      # @return [Array<String>]
      def i18n_load_directories
        @i18n_load_directories ||= relative_i18n_load_directories.collect { |relative_i18n_load_path|
          root.join(relative_i18n_load_path).to_path
        }
      end

      # Absolute paths to I18n .yml files.
      #
      # @return [Array<String>]
      def i18n_load_paths
        @i18n_load_paths ||= i18n_load_directories.flat_map { |i18n_load_directory|
          glob = File.join(i18n_load_directory, '*.yml')
          Dir.glob(glob)
        }
      end

      # Relative paths to I18n directories.
      #
      # @return [Array<String>]
      def relative_i18n_load_directories
        @relative_i18n_load_directories ||= [
           File.join('config', 'locales')
        ]
      end

      # Adds {#i18n_load_paths} to `I18n.load_path` if they are not already there.
      #
      # @return [void]
      def set_i18n_load_paths
        i18n_load_paths.each do |i18n_load_path|
          unless ::I18n.load_path.include? i18n_load_path
            ::I18n.load_path << i18n_load_path
          end
        end
      end
    end
  end
end