# Code shared between `Mdm::Module::Author` and `Metasploit::Framework::Module::Author`.
module Metasploit::Model::Module::Author
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  include Metasploit::Model::Translation

  included do
    include ActiveModel::Validations

    #
    # Validations
    #

    validates :author,
              :presence => true
    validates :module_instance,
              :presence => true
  end

  #
  # Associations
  #

  # @!attribute [rw] author
  #   Author who wrote the {#module_instance module}.
  #
  #   @return [Metasploit::Model::Author]

  # @!attribute [rw] email_address
  #   Email address {#author} used when writing {#module_instance module}.
  #
  #   @return [Metasploit::Model::EmailAddress] if {#author} gave an email address.
  #   @return [nil] if {#author} only gave a name.

  # @!attribute [rw] module_instance
  #   Module written by {#author}.
  #
  #   @return [Metasploit::Model::Module::Instance]
end
