# Implementation of {Metasploit::Model::Module::Class} to allow testing of {Metasploit::Model::Module::Class}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Class < Metasploit::Model::Base
  include Metasploit::Model::Module::Class

  #
  # Associations
  #

  # @!attribute [rw] rank
  #   The reliability of the module and likelyhood that the module won't knock over the service or host being
  #   exploited.  Bigger values is better.
  #
  #   @return [Dummy::Module::Rank]
  attr_accessor :rank

  # @!attribute [r] ancestors
  #   The Class or Modules that were loaded to make this module Class.
  #
  #   @return [Array<Dummy::Module::Ancestor>]
  attr_writer :ancestors

  #
  # Attributes
  #

  # @!attribute [rw] full_name
  #   The full name (type + reference) for the Class<Msf::Module>.  This is merely a denormalized cache of
  #   `"#{{#module_type}}/#{{#reference_name}}"` as full_name is used in numerous queries and reports.
  #
  #   @return [String]
  attr_accessor :full_name

  # @!attribute [rw] module_type
  #   A denormalized cache of the {Metasploit::Model::Module::Class#module_type ancestors' module_types}, which
  #   must all be the same.  This cache exists so that queries for modules of a given type don't need include the
  #   {#ancestors}.
  #
  #   @return [String]
  attr_accessor :module_type

  # @!attribute [rw] payload_type
  #   For payload modules, the {PAYLOAD_TYPES type} of payload, either 'single' or 'staged'.
  #
  #   @return [String] if {#payload?} is `true`.
  #   @return [nil] if {#payload?} is `false`
  attr_accessor :payload_type

  # @!attribute [rw] reference_name
  #   The reference name for the Class<Msf::Module>. For non-payloads, this will just be
  #   {Mdm::Module::Ancestor#reference_name} for the only element in {#ancestors}.  For payloads composed of a
  #   stage and stager, the reference name will be derived from the
  #   {Metasplit::Model::Module::Ancestor#reference_name} of each element {#ancestors} or an alias defined in
  #   those Modules.
  #
  #   @return [String
  attr_accessor :reference_name

  #
  # Methods
  #

  # List of ancestors included in this module Class.
  #
  # @return [Array<Dummy::Module::Ancestor>]
  def ancestors
    @ancestors ||= []
  end
end