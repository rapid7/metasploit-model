# Implementation of {Metasploit::Model::Module::Target} to allow testing of {Metasploit::Model::Module::Target}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Target < Metasploit::Model::Base
  include Metasploit::Model::Module::Target

  #
  # Associations
  #

  # @!attribute [rw] module_instance
  #   Module where this target was declared.
  #
  #   @return [Dummy::Module::Instance]
  attr_accessor :module_instance

  #
  # Attributes
  #

  # @!attribute [rw] index
  #   Index of this target among other {Dummy::Module::Instance#targets targets} for
  #   {#module_instance}.  The default target is usually specified by index in the module code, so the indices for
  #   targets is mirror here for easier correlation.  The default target is an
  #   {Dummy::Module::Instance#default_target association} on {Dummy::Module::Instance},
  #   not an index like in the code for easier reporting and searching.
  #
  #   @return [Integer]
  attr_accessor :index

  # @!attribute [rw] name
  #   The name of this target.
  #
  #   @return [String]
  attr_accessor :name
end
