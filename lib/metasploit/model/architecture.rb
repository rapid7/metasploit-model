# Code shared between `Mdm::Architecture` and `Metasploit::Framework::Architecture`.
module Metasploit::Model::Architecture
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  #
  # CONSTANTS
  #

  # Valid values for {#abbreviation}
  ABBREVIATIONS = [
      'armbe',
      'armle',
      'cbea',
      'cbea64',
      'cmd',
      'dalvik',
      'firefox',
      'java',
      'mipsbe',
      'mipsle',
      'nodejs',
      'php',
      'ppc',
      'ppc64',
      'python',
      'ruby',
      'sparc',
      'tty',
      'x86',
      'x86_64'
  ]
  # Valid values for {#bits}.
  BITS = [
      32,
      64
  ]
  # Valid values for {#endianness}.
  ENDIANNESSES = [
      'big',
      'little'
  ]
  # Valid values for {#family}.
  FAMILIES = [
      'arm',
      'cbea',
      'javascript',
      'mips',
      'ppc',
      'sparc',
      'x86'
  ]
  # Attributes for seeds.  Ensures that in-database seeds for `Mdm::Architecture` and in-memory seeds for
  # `Metasploit::Framework::Architecture` are the same.
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
          :abbreviation => 'dalvik',
          :bits => nil,
          :endianness => nil,
          :family => nil,
          :summary => 'Dalvik process virtual machine used in Google Android'
      },
      {
          abbreviation: 'firefox',
          bits: nil,
          endianness: nil,
          family: 'javascript',
          summary: "Firefox's privileged javascript API"
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
          abbreviation: 'nodejs',
          bits: nil,
          endianness: nil,
          family: 'javascript',
          summary: 'NodeJS'
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
          :abbreviation => 'python',
          :bits => nil,
          :endianness => nil,
          :family => nil,
          :summary => 'Python'
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

  included do
    include ActiveModel::Validations
    include Metasploit::Model::Search

    #
    # Search Attributes
    #

    search_attribute :abbreviation,
                     type: {
                         set: :string
                     }
    search_attribute :bits,
                     type: {
                         set: :integer
                     }
    search_attribute :endianness,
                     type: {
                         set: :string
                     }
    search_attribute :family,
                     type: {
                         set: :string
                     }

    #
    # Validations
    #

    validates :abbreviation,
              :inclusion => {
                  :in => ABBREVIATIONS
              }
    validates :bits,
              :inclusion => {
                  :allow_nil => true,
                  :in => BITS
              }
    validates :endianness,
              :inclusion => {
                  :allow_nil => true,
                  :in => ENDIANNESSES
              }
    validates :family,
              :inclusion => {
                  :allow_nil => true,
                  :in => FAMILIES
              }
    validates :summary,
              :presence => true
  end

  # Adds <attribute>_set methods to class.
  module ClassMethods
    # Set of valid values to search for `attribute`.  Does not include `nil` as search syntax cannot differentiate
    # '' and nil when parsing.
    #
    # @param attribute [Symbol] attribute name.
    # @return [Set]
    def self.set(attribute)
      SEED_ATTRIBUTES.each_with_object(Set.new) { |attributes, set|
        value = attributes.fetch(attribute)

        unless value.nil?
          set.add value
        end
      }
    end

    # @!method abbreviation_set
    #   Set of valid {Metasploit::Model::Architecture#abbreviation} for search.
    #
    #   @return [Set<String>]
    #
    # @!method bits_set
    #   Set of valid {Metasploit::Model::Architecture#bits} for search.
    #
    #   @return [Set<Integer>]
    #
    # @!method endianness_set
    #   Set of valid {Metasploit::Model::Architecture#endianness} for search.
    #
    #   @return [Set<String>]
    #
    # @!method family_set
    #   Set of valid {Metasploit::Model::Architecture#family} for search.
    #
    #   @return [Set<String>]
    [:abbreviation, :bits, :endianness, :family].each do |attribute|
      # calculate external to method so it is only calculated once
      set = self.set(attribute)

      define_method("#{attribute}_set") do
        set
      end
    end
  end

  #
  # Associations
  #

  # @!attribute [r] module_instances
  #   {Metasploit::Model::Module::Instance Modules} that have this {Metasploit::Model::Module::Architecture} as a
  #   {Metasploit::Model::Module::Instance#architectures support architecture}.
  #
  #   @return [Array<Metasploit::Model::Module::Instance>]

  #
  # Attributes
  #

  # @!attribute [rw] abbreviation
  #   Abbreviation used for the architecture.  Will match ARCH constants in metasploit-framework.
  #
  #   @return [String]

  # @!attribute [rw] bits
  #   Number of bits supported by this architecture.
  #
  #   @return [32] if 32-bit
  #   @return [64] if 64-bit
  #   @return [nil] if bits aren't applicable, such as for non-CPU architectures like ruby, etc.

  # @!attribute [rw] endianness
  #   The endianness of the architecture.
  #
  #   @return ['big'] if big endian
  #   @return ['little'] if little endian
  #   @return [nil] if endianness is not applicable, such as for software architectures like tty.

  # @!attribute [rw] family
  #   The CPU architecture family.
  #
  #   @return [String] if a CPU architecture.
  #   @return [nil] if not a CPU architecture.

  # @!attribute [rw] summary
  #   Sentence length summary of architecture.  Usually an expansion of the abbreviation or initialism in the
  #   {#abbreviation} and the {#bits} and {#endianness} in prose.
  #
  #   @return [String]
end
