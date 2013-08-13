module Metasploit
  module Model
    # Code shared between `Mdm::Architecture` and `Metasploit::Framework::Architecture`.
    module Architecture
      extend ActiveSupport::Concern
      extend Metasploit::Model::Search::Translation

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
          'java',
          'mipsbe',
          'mipsle',
          'php',
          'ppc',
          'ppc64',
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
          'mips',
          'ppc',
          'sparc',
          'x86'
      ]

      included do
        include ActiveModel::Validations
        include Metasploit::Model::Search

        #
        # Search Attributes
        #

        search_attribute :abbreviation, :type => :string
        search_attribute :bits, :type => :integer
        search_attribute :endianness, :type => :string
        search_attribute :family, :type => :string

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
  end
end