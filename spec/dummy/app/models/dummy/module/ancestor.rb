# Implementation of {Metasploit::Model::Module::Ancestor} to allow testing of {Metasploit::Model::Module::Ancestor}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Ancestor < Metasploit::Model::Base
  include Metasploit::Model::Module::Ancestor

  #
  # Attributes
  #

  # @!attribute [rw] full_name
  #   Full name to module including {#module_type} and {#reference_name}
  #
  #   @return [String] <module_type>/<reference_name>
  attr_accessor :full_name

  # @!attribute [rw] handler_type
  #   The handler type (in the case of singles) or (in the case of stagers) the handler type alias.  Handler type is
  #   appended to the end of the single's or stage's {#reference_name} to get the
  #   {Metasploit::Model::Module::Class#reference_name}.
  #
  #   @return [String] if {#handled?} is `true`.
  #   @return [nil] if {#handled?} is `false`.
  attr_accessor :handler_type

  # @!attribute [rw] module_type
  #   The type of module of this ancestor.
  #
  #   @return [String]
  attr_accessor :module_type

  # @!attribute [rw] parent_path
  #   Module path on which this ancestor exists.
  #
  #   @return [Metasploit::Model::Module::Path]
  attr_accessor :parent_path

  # @!attribute [rw] payload_type
  #   The type of payload module this ancestor is.
  #
  #   @return [String] if this is a payload module.
  #   @return [nil] if this is not a payload module.
  attr_accessor :payload_type

  # @!attribute [rw] real_path
  #   The real (absolute) path to this ancestor on-disk.
  #
  #   @return [String]
  attr_accessor :real_path

  # @!attribute [rw] real_path_modified_at
  #   The modification time of {#real_path}.
  #
  #   @return [DateTime]
  attr_accessor :real_path_modified_at

  # @!attribute [rw] real_path_sha1_hex_digest
  #   SHA1 hex digest of the contents of {#real_path}.
  #
  #   @return [String]
  attr_accessor :real_path_sha1_hex_digest

  # @!attribute [rw] reference_name
  #   Reference name to this ancestor, scoped to {#module_type}.
  #
  #   @return [String]
  attr_accessor :reference_name
end