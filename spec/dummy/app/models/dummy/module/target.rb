# Implementation of {Metasploit::Model::Module::Target} to allow testing of {Metasploit::Model::Module::Target}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Target < Metasploit::Model::Base
  include Metasploit::Model::Module::Target

  #
  # Associations
  #


  # @!attribute [r] architectures
  #   Architectures that this target supports, either by being declared specifically for this target or because
  #   this target did not override architectures and so inheritted the architecture set from the class.
  #
  #   @return [Array<Metasploit::Model::Architecture>]
  def architectures
    target_architectures.map(&:architecture)
  end

  # @!attribute [rw] module_instance
  #   Module where this target was declared.
  #
  #   @return [Dummy::Module::Instance]
  attr_accessor :module_instance

  # @!attribute [r] platforms
  #   Platforms that this target supports, either by being declared specifically for this target or because this
  #   target did not override platforms and so inheritted the platform set from the class.
  #
  #   @return [Array<Metasploit::Model::Platform>]
  def platforms
    target_platforms.map(&:platform)
  end

  # @!attribute [rw] target_architectures
  #   Joins this target to its {#architectures}
  #
  #   @return [Array<Metasploit::Model::Module::Target::Architecture]
  def target_architectures
    @target_architectures ||= []
  end
  attr_writer :target_architectures

  # @!attribute [rw] target_platforms
  #   Joins this target to its {#platforms}
  #
  #   @return [Array<Metasploit::Model::Module::Target::Platform>]
  def target_platforms
    @target_platforms ||= []
  end
  attr_writer :target_platforms

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
