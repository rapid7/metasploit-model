module Metasploit
  module Model
    module Module
      # Code shared between `Mdm::Module::Ancestor` and `Metasploit::Framework::Module::Ancestor`.
      module Ancestor
        extend ActiveSupport::Concern

        #
        # CONSTANTS
        #

        # The directory for a given #module_type is a not always the pluralization of #module_type, so this maps the
        # #module_type to the type directory that is used to generate the #real_path from the #module_type and
        # #reference_name.
        DIRECTORY_BY_MODULE_TYPE = {
            Metasploit::Model::Module::Type::AUX => Metasploit::Model::Module::Type::AUX,
            Metasploit::Model::Module::Type::ENCODER => Metasploit::Model::Module::Type::ENCODER.pluralize,
            Metasploit::Model::Module::Type::EXPLOIT => Metasploit::Model::Module::Type::EXPLOIT.pluralize,
            Metasploit::Model::Module::Type::NOP => Metasploit::Model::Module::Type::NOP.pluralize,
            Metasploit::Model::Module::Type::PAYLOAD => Metasploit::Model::Module::Type::PAYLOAD.pluralize,
            Metasploit::Model::Module::Type::POST => Metasploit::Model::Module::Type::POST
        }

        # File extension used for metasploit modules.
        EXTENSION = '.rb'

        # The {#payload_type payload types} that require {#handler_type}.
        HANDLED_TYPES = [
            'single',
            'stager'
        ]

        # Valid values for {#payload_type} if {#payload?} is `true`.
        PAYLOAD_TYPES = [
            'single',
            'stage',
            'stager'
        ]

        # Regexp to keep '\' out of reference names
        REFERENCE_NAME_REGEXP = /\A[a-z][a-z_0-9]*(?:\/[a-z][a-z_0-9]*)*\Z/

        # Regular expression matching a full SHA-1 hex digest.
        SHA1_HEX_DIGEST_REGEXP = /\A[0-9a-z]{40}\Z/

        included do
          include ActiveModel::MassAssignmentSecurity
          include ActiveModel::Validations
          include ActiveModel::Validations::Callbacks
          include Metasploit::Model::Derivation
          include Metasploit::Model::Derivation::FullName


          #
          # Derivations
          #

          derives :full_name, :validate => true
          derives :payload_type, :validate => true
          derives :real_path, :validate => true

          # Don't validate attributes that require accessing file system to derive value
          derives :real_path_modified_at, :validate => false
          derives :real_path_sha1_hex_digest, :validate => false

          #
          # Mass Assignment Security
          #

          # full_name is NOT accessible since it's derived and must match {#derived_full_name} so there's no reason for a
          # user to set it.
          # handler_type is accessible because it's needed to derive {Mdm::Module::Class#reference_name}.
          attr_accessible :handler_type
          # module_type is accessible because it's needed to derive {#full_name} and {#real_path}.
          attr_accessible :module_type
          # payload_type is NOT accessible since it's derived and must match {#derived_payload_type}.
          # reference_name is accessible because it's needed to derive {#full_name} and {#real_path}.
          attr_accessible :reference_name
          # real_path is NOT accessible since it must match {#derived_real_path}.
          # real_path_modified_at is NOT accessible since it's derived
          # real_path_sha1_hex_digest is NOT accessible since it's derived

          #
          # Validations
          #

          validates :handler_type,
                    :nil => {
                        :unless => :handled?
                    },
                    :presence => {
                        :if => :handled?
                    }
          validates :module_type,
                    :inclusion => {
                        :in => Metasploit::Model::Module::Type::ALL
                    }
          validates :parent_path,
                    :presence => true
          validates :payload_type,
                    :inclusion => {
                        :if => :payload?,
                        :in => PAYLOAD_TYPES
                    },
                    :nil => {
                        :unless => :payload?
                    }
          validates :real_path_modified_at,
                    :presence => true
          validates :real_path_sha1_hex_digest,
                    :format => {
                        :with => SHA1_HEX_DIGEST_REGEXP
                    }
          validates :reference_name,
                    :format => {
                        :with => REFERENCE_NAME_REGEXP
                    }
        end

        module ClassMethods
          # Returns whether {#handler_type} is required or must be `nil` for the given payload_type.
          #
          # @param options [Hash{Symbol => String,nil}]
          # @option options [String, nil] module_type (nil) `nil` or an element of
          #   `Metasploit::Model::Module::Ancestor::MODULE_TYPES`.
          # @option options [String, nil] payload_type (nil) `nil` or an element of {PAYLOAD_TYPES}.
          # @return [true] if {#handler_type} must be present.
          # @return [false] if {#handler_type} must be `nil`.
          def handled?(options={})
            options.assert_valid_keys(:module_type, :payload_type)

            handled = false
            module_type = options[:module_type]
            payload_type = options[:payload_type]

            if module_type == 'payload' and HANDLED_TYPES.include? payload_type
              handled = true
            end

            handled
          end
        end

        #
        # Instance Methods
        #

        # Derives {#payload_type} from {#reference_name}.
        #
        # @return [String]
        # @return [nil] if {#payload_type_directory} is `nil`
        def derived_payload_type
          derived = nil
          directory = payload_type_directory

          if directory
            derived = directory.singularize
          end

          derived
        end

        # Derives {#real_path} by combining {Mdm::Module::Path#real_path parent_path.real_path}, {#module_type_directory}, and
        # {#reference_path} in the same way the module loader does in metasploit-framework.
        #
        # @return [String] the real path to the file holding the ruby Module or ruby Class represented by this
        #   {Mdm::Module::Ancestor}.
        # @return [nil] if {#parent_path} is `nil`.
        # @return [nil] if {Mdm::Module::Path#real_path parent_path.real_path} is `nil`.
        # @return [nil] if {#module_type_directory} is `nil`.
        # @return [nil] if {#reference_name} is `nil`.
        def derived_real_path
          derived_real_path = nil

          if parent_path and parent_path.real_path and module_type_directory and reference_path
            # Have to use ::File as File resolves to Metasploit::Model::File
            derived_real_path = ::File.join(
                parent_path.real_path,
                module_type_directory,
                reference_path
            )
          end

          derived_real_path
        end

        # Derives {#real_path_modified_at} by getting the modification time of the file on-disk.
        #
        # @return [Time] modification time of {#real_path} if {#real_path} exists on disk and modification time can be
        #   queried by user.
        # @return [nil] if {#real_path} does not exist or user cannot query the file's modification time.
        def derived_real_path_modified_at
          real_path_string = real_path.to_s

          begin
            # Have to use ::File as File resolves to Metasploit::Model::File
            mtime = ::File.mtime(real_path_string)
          rescue Errno::ENOENT
            nil
          else
            mtime.utc
          end
        end

        # Derives {#real_path_sha1_hex_digest} by running the contents of {#real_path} through Digest::SHA1.hexdigest.
        #
        # @return [String] 40 character SHA1 hex digest if {#real_path} can be read.
        # @return [nil] if {#real_path} cannot be read.
        def derived_real_path_sha1_hex_digest
          begin
            sha1 = Digest::SHA1.file(real_path.to_s)
          rescue Errno::ENOENT
            hex_digest = nil
          else
            hex_digest = sha1.hexdigest
          end

          hex_digest
        end

        # Returns whether {#handler_type} is required or must be `nil`.
        #
        # @return (see handled?)
        # @see handled?
        def handled?
          self.class.handled?(
              :module_type => module_type,
              :payload_type => payload_type
          )
        end

        # The directory for {#module_type} under {Mdm::Module::Path parent_path.real_path}.
        #
        # @return [String]
        # @see Metasploit::Model::Module::Ancestor::DIRECTORY_BY_MODULE_TYPE
        def module_type_directory
          Metasploit::Model::Module::Ancestor::DIRECTORY_BY_MODULE_TYPE[module_type]
        end

        # Return whether this forms part of a payload (either a single, stage, or stager).
        #
        # @return [true] if {#module_type} == 'payload'
        # @return [false] if {#module_type} != 'payload'
        def payload?
          if module_type == Metasploit::Model::Module::Type::PAYLOAD
            true
          else
            false
          end
        end

        # The directory for {#payload_type} under {#module_type_directory} in {#real_path}.
        #
        # @return [String] first directory in reference_name
        # @return [nil] if {#payload?} is `false`.
        # @return [nil] if {#reference_name} is `nil`.
        def payload_type_directory
          directory = nil

          if payload? and reference_name
            head, _tail = reference_name.split('/', 2)
            directory = head.singularize
          end

          directory
        end

        # The path relative to the {#module_type_directory} under the {Mdm::Module::Path parent_path.real_path}, including the
        # file {EXTENSION extension}.
        #
        # @return [String] {#reference_name} + {EXTENSION}
        # @return [nil] if {#reference_name} is `nil`.
        def reference_path
          path = nil

          if reference_name
            path = "#{reference_name}#{EXTENSION}"
          end

          path
        end
      end
    end
  end
end