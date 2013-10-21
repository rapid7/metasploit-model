# Implementation of {Metasploit::Model::Architecture} to allow testing of {Metasploit::Model::Architecture} using an
# in-memory ActiveModel and use of factories.
class Dummy::Architecture < Metasploit::Model::Base
  include Metasploit::Model::Architecture

  #
  # Associations
  #

  # @!attribute [r] module_instances
  #   {Dummy::Module::Instance Modules} that have this {Metasploit::Model::Module::Architecture} as a
  #   {Dummy::Module::Instance#architectures support architecture}.
  #
  #   @return [Array<Metasploit::Model::Module::Instance>]

  #
  # Attributes
  #

  # @!attribute [rw] abbreviation
  #   Abbreviation used for the architecture.  Will match ARCH constants in metasploit-framework.
  #
  #   @return [String]
  attr_accessor :abbreviation

  # @!attribute [rw] bits
  #   Number of bits supported by this architecture.
  #
  #   @return [32] if 32-bit
  #   @return [64] if 64-bit
  #   @return [nil] if bits aren't applicable, such as for non-CPU architectures like ruby, etc.
  attr_accessor :bits

  # @!attribute [rw] endianness
  #   The endianness of the architecture.
  #
  #   @return ['big'] if big endian
  #   @return ['little'] if little endian
  #   @return [nil] if endianness is not applicable, such as for software architectures like tty.
  attr_accessor :endianness

  # @!attribute [rw] family
  #   The CPU architecture family.
  #
  #   @return [String] if a CPU architecture.
  #   @return [nil] if not a CPU architecture.
  attr_accessor :family

  # @!attribute [rw] summary
  #   Sentence length summary of architecture.  Usually an expansion of the abbreviation or initialism in the
  #   {#abbreviation} and the {#bits} and {#endianness} in prose.
  #
  #   @return [String]
  attr_accessor :summary

  #
  # Methods
  #

  def self.all
    instance_by_abbreviation.values
  end

  def self.instance_by_abbreviation
    unless instance_variable_defined? :@instance_by_abbreviation
      @instance_by_abbreviation = {}

      SEED_ATTRIBUTES.each do |attributes|
        instance = new(attributes)

        unless instance.valid?
          raise Metasploit::Model::Invalid.new(instance)
        end

        # freeze object to prevent specs from modifying them and interfering with other specs.
        instance.freeze

        @instance_by_abbreviation[instance.abbreviation] = instance
      end
    end

    @instance_by_abbreviation
  end

  # Keep single instance for each set of attributes in {SEED_ATTRIBUTES} to emulate unique database seeds in-memory.
  #
  # @param abbreviation [String] {#abbreviation}
  # @return [Dummy::Architecture]
  def self.with_abbreviation(abbreviation)
    instance_by_abbreviation.fetch(abbreviation)
  end
end
