# Implementation of {Metasploit::Model::Module::Instance} to allow testing of {Metasploit::Model::Module::Instance}
# using an in-memory ActiveModel and use of factories.
class Dummy::Module::Instance < Metasploit::Model::Base
  include Metasploit::Model::Association
  include Metasploit::Model::Module::Instance

  #
  #
  # Associations
  #
  #

  association :actions, :class_name => 'Dummy::Module::Action'
  association :architectures, :class_name => 'Dummy::Architecture'
  association :authorities, :class_name => 'Dummy::Authority'
  association :authors, :class_name => 'Dummy::Author'
  association :email_addresses, :class_name => 'Dummy::EmailAddress'
  association :module_class, :class_name => 'Dummy::Module::Class'
  association :platforms, :class_name => 'Dummy::Platform'
  association :rank, :class_name => 'Dummy::Module::Rank'
  association :references, :class_name => 'Dummy::Reference'
  association :targets, :class_name => 'Dummy::Module::Target'

  # @!attribute [rw] actions
  #   Auxiliary actions to perform when this running this module.
  #
  #   @return [Array<Dummy::Module::Action>]
  def actions
    @actions ||= []
  end
  attr_writer :actions

  # @!attribute [rw] default_action
  #   The default action in {#actions}.
  #
  #   @return [Dummy::Module::Action]
  attr_accessor :default_action

  # @!attribute [rw] default_target
  #   The default target in {#targets}.
  #
  #   @return [Dummy::Module::Target]
  attr_accessor :default_target

  # @!attribute [rw] module_architectures
  #   Joins this module instance to the {#architectures} it supports.
  #
  #   @return [Array<Dummy::Module::Architecture>]
  def module_architectures
    @module_architectures ||= []
  end
  attr_writer :module_architectures

  # @!attribute [rw] module_authors
  #   Joins this with {#authors} and {#email_addresses} to model the name and email address used for an author
  #   entry in the module metadata.
  #
  #   @return [Array<Dummy::Module::Author>]
  def module_authors
    @module_authors ||= []
  end
  attr_writer :module_authors

  # @!attribute [rw] module_class
  #   Class-derived metadata to go along with the instance-derived metadata in this model.
  #
  #   @return [Dummy::Module::Class]
  attr_accessor :module_class

  # @!attribute [rw] module_platforms
  #   Joins this with the {#platforms} it supports.
  #
  #   @return [Array<Dummy::Module::Platform>]
  def module_platforms
    @module_platforms ||= []
  end
  attr_writer :module_platforms

  # @!attribute [rw] module_references
  #   Joins this with the {#references} to the exploit of this module.
  #
  #   @return [Array<Dummy::Module::Reference>]
  def module_references
    @module_references ||= []
  end
  attr_writer :module_references

  # @!attribute [rw] targets
  #   Names of targets with different configurations that can be exploited by this module.
  #
  #   @return [Array<Dummy::Module::Target>]
  def targets
    @targets ||= []
  end
  attr_writer :targets

  # @!attribute [r] architectures
  #   The {Dummy::Architecture architectures} supported by this module.
  #
  #   @return [Array<Dummy::Architecture>]
  def architectures
    module_architectures.map(&:architecture)
  end

  # @!attribute [r] authors
  #   The names of the authors of this module.
  #
  #   @return [Array<Dummy::Author>]
  def authors
    module_authors.map(&:author)
  end

  # @!attribute [r] email_addresses
  #   The email addresses of the authors of this module.
  #
  #   @return [Array<Dummy::EmailAddress>]
  def email_addresses
    module_authors.map(&email_addresses).uniq
  end

  # @!attribute [r] platforms
  #   Platforms supported by this module.
  #
  #   @return [Array<Dummy::Module::Platform>]
  def platforms
    module_platforms.map(&:platform)
  end

  # @!attribute [r] references
  #   External references to the exploit or proof-of-concept (PoC) code in this module.
  #
  #   @return [Array<Dummy::Reference>]
  def references
    module_references.map(&:reference)
  end

  # @!attribute [r] vulns
  #   Vulnerabilities with same {Dummy::Reference reference} as this module.
  #
  #   @return [Array<Dummy::Vuln>]
  def vulns
    references.inject(Set.new) { |vuln_set, reference|
      vuln_set.merge(reference.vulns)
    }
  end

  # @!attribute [r] vulnerable_hosts
  #   Hosts vulnerable to this module.
  #
  #   @return [Array<Dummy::Host>]
  def vulnerable_hosts
    vulns.inject(Set.new) { |host_set, vuln|
      host_set.add(vuln.host)
    }
  end

  # @!attribute [r] vulnerable_services
  #   Services vulnerable to this module.
  #
  #   @return [Array<Dummy::Service>]
  def vulnerable_services
    vulns.inject(Set.new) { |service_set, vuln|
      service_set.merge(vuln)
    }
  end

  #
  # Attributes
  #

  # @!attribute [rw] description
  #   A long, paragraph description of what the module does.
  #
  #   @return [String]
  attr_accessor :description

  # @!attribute [rw] disclosed_on
  #   The date the vulnerability exploited by this module was disclosed to the public.
  #
  #   @return [Date, nil]
  attr_accessor :disclosed_on

  # @!attribute [rw] license
  #   The name of the software license for the module's code.
  #
  #   @return [String]
  attr_accessor :license

  # @!attribute [rw] name
  #   The human readable name of the module.  It is unrelated to {Dummy::Module::Class#full_name} or
  #   {Dummy::Module::Class#reference_name} and is better thought of as a short summary of the
  #   {#description}.
  #
  #   @return [String]
  attr_accessor :name

  # @!attribute [rw] privileged
  #   Whether this module requires privileged access to run.
  #
  #   @return [Boolean]
  attr_accessor :privileged

  # @!attribute [rw] stance
  #   Whether the module is active or passive.  `nil` if the
  #   {Dummy::Module::Class#module_type module type} does not {#supports_stance? support stances}.
  #
  #   @return ['active', 'passive', nil]
  attr_accessor :stance
end
