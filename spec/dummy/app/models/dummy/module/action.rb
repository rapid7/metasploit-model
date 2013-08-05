# Implementation of {Metasploit::Model::Module::Action} to allow testing of {Metasploit::Model::Module::Action}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Action < Metasploit::Model::Base
  include Metasploit::Model::Module::Action

  #
  # Associations
  #

  # @!attribute [rw] module_instance
  #   Module that has this action.
  #
  #   @return [Dummy::Module::Instance]
  attr_accessor :module_instance

  #
  # Attributes
  #

  # @!attribute [rw] name
  #   The name of this action.
  #
  #   @return [String]
  attr_accessor :name
end
