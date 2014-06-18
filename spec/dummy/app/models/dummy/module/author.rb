# Implementation of {Metasploit::Model::Module::Author} to allow testing of {Metasploit::Model::Module::Author}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Author < Metasploit::Model::Base
  include Metasploit::Model::Module::Author

  #
  # Associations
  #

  # @!attribute [rw] author
  #   Author who wrote the {#module_instance module}.
  #
  #   @return [Dummy::Author]
  attr_accessor :author

  # @!attribute [rw] email_address
  #   Email address {#author} used when writing {#module_instance module}.
  #
  #   @return [Dummy::EmailAddress] if {#author} gave an email address.
  #   @return [nil] if {#author} only gave a name.
  attr_accessor :email_address

  # @!attribute [rw] module_instance
  #   Module written by {#author}.
  #
  #   @return [Dummy::Module::Instance]
  attr_accessor :module_instance
end
