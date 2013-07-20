# Implementation of {Metasploit::Model::Architecture} to allow testing of {Metasploit::Model::Architecture} using an
# in-memory ActiveModel and use of factories.
class Dummy::Architecture < Metasploit::Model::Base
  include Metasploit::Model::Architecture

  #
  # CONSTANTS
  #

  # List of attributes for seeds.
  SEED_ATTRIBUTES = [
      {
          :abbreviation => 'armbe',
          :bits => 32,
          :endianness => 'big',
          :family => 'arm',
          :summary => 'Little-endian ARM'
      },
      {
          :abbreviation => 'armle',
          :bits => 32,
          :endianness => 'little',
          :family => 'arm',
          :summary => 'Big-endian ARM'
      },
      {
          :abbreviation => 'cbea',
          :bits => 32,
          :endianness => 'big',
          :family => 'cbea',
          :summary => '32-bit Cell Broadband Engine Architecture'
      },
      {
          :abbreviation => 'cbea64',
          :bits => 64,
          :endianness => 'big',
          :family => 'cbea',
          :summary => '64-bit Cell Broadband Engine Architecture'
      },
      {
          :abbreviation => 'cmd',
          :bits => nil,
          :endianness => nil,
          :family => nil,
          :summary => 'Command Injection'
      },
      {
          :abbreviation => 'java',
          :bits => nil,
          :endianness => 'big',
          :family => nil,
          :summary => 'Java'
      },
      {
          :abbreviation => 'mipsbe',
          :bits => 32,
          :endianness => 'big',
          :family => 'mips',
          :summary => 'Big-endian MIPS'
      },
      {
          :abbreviation => 'mipsle',
          :bits => 32,
          :endianness => 'little',
          :family => 'mips',
          :summary => 'Little-endian MIPS'
      },
      {
          :abbreviation => 'php',
          :bits => nil,
          :endianness => nil,
          :family => nil,
          :summary => 'PHP'
      },
      {
          :abbreviation => 'ppc',
          :bits => 32,
          :endianness => 'big',
          :family => 'ppc',
          :summary => '32-bit Peformance Optimization With Enhanced RISC - Performance Computing'
      },
      {
          :abbreviation => 'ppc64',
          :bits => 64,
          :endianness => 'big',
          :family => 'ppc',
          :summary => '64-bit Performance Optimization With Enhanced RISC - Performance Computing'
      },
      {
          :abbreviation => 'ruby',
          :bits => nil,
          :endianness => nil,
          :family => nil,
          :summary => 'Ruby'
      },
      {
          :abbreviation => 'sparc',
          :bits => nil,
          :endianness => nil,
          :family => 'sparc',
          :summary => 'Scalable Processor ARChitecture'
      },
      {
          :abbreviation => 'tty',
          :bits => nil,
          :endianness => nil,
          :family => nil,
          :summary => '*nix terminal'
      },
      {
          :abbreviation => 'x86',
          :bits => 32,
          :endianness => 'little',
          :family => 'x86',
          :summary => '32-bit x86'
      },
      {
          :abbreviation => 'x86_64',
          :bits => 64,
          :endianness => 'little',
          :family => 'x86',
          :summary => '64-bit x86'
      }
  ]

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

  # Keep single instance for each set of attributes in {SEED_ATTRIBUTES} to emulate unique database seeds in-memory.
  #
  # @param abbreviation [String] {#abbreviation}
  # @return [Dummy::Architecture]
  def self.by_abbreviation(abbreviation)
    unless instance_variable_defined? :@instance_by_abbreviation
      @instance_by_abbreviation = {}

      SEED_ATTRIBUTES.each do |attributes|
        instance = new(attributes)

        unless instance.valid?
          raise Metasploit::Model::Invalid.new(instance)
        end

        @instance_by_abbreviation[instance.abbreviation] = instance
      end
    end

    @instance_by_abbreviation.fetch(abbreviation)
  end
end
