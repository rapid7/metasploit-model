# Implementation of {Metasploit::Model::Platform} to allow testing of {Metasploit::Model::Platform} using an in-memory
# ActiveModel and use of factories.
class Dummy::Platform < Metasploit::Model::Base
  include Metasploit::Model::Platform

  #
  # Attributes
  #

  # @!attribute [rw] fully_qualified_name
  #   The fully qualified name of this platform, as would be used in the platform list in a metasploit-framework
  #   module.
  #
  #   @return [String]
  attr_accessor :fully_qualified_name

  # @!attribute [rw] parent
  #   The parent platform of this platform.  For example, Windows is parent of Windows 98, which is the parent of
  #   Windows 98 FE.
  #
  #   @return [nil] if this is a top-level platform, such as Windows or Linux.
  #   @return [Metasploit::Model::Platform]
  attr_accessor :parent

  # @!attribute [rw] relative_name
  #   The name of this platform relative to the {#fully_qualified_name} of {#parent}.
  #
  #   @return [String]
  attr_accessor :relative_name

  #
  # Methods
  #

  def self.all
    # cache so that Dummy::Platform can be compared by identity
    unless instance_variable_defined? :@all
      @all = []

      Metasploit::Model::Platform.each_seed_attributes do |attributes|
        child = new(attributes)
        # validate to populate {#fully_qualified_name}
        child.valid!

        @all << child

        # yieldreturn
        child
      end

      # freeze objects to prevent specs from modifying them and interfering with other specs.
      @all.map(&:freeze)
    end

    @all
  end
end

