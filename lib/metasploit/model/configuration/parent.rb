# DSL for declaring {Metasploit::Model::Configuration::Child children} of {Metasploit::Model::Configuration}
module Metasploit::Model::Configuration::Parent
  # Declares a {Metasploit::Model::Configuration::Child} with the given `name`.
  #
  # @param name [Symbol] The name of the child.
  # @return [void]
  def child(name)
    child_class_attribute_name = "#{name}_class"
    child_class_instance_variable_name = "@#{child_class_attribute_name}".to_sym
    child_instance_variable_name = "@#{name}".to_sym

    #
    # Attributes
    #

    # @!attribute [rw] <name>_class
    #   The `Class` used to create {#<name>}.
    #
    #   @return [Class]
    attr_writer child_class_attribute_name

    #
    # Methods
    #

    define_method(name) do
      unless instance_variable_defined? child_instance_variable_name
        child_instance = send(child_class_attribute_name).new
        child_instance.configuration = self

        instance_variable_set child_instance_variable_name, child_instance
      end

      instance_variable_get child_instance_variable_name
    end

    define_method(child_class_attribute_name) do
      child_class = instance_variable_get child_class_instance_variable_name

      unless child_class
        require "metasploit/model/configuration/#{name}"

        child_class = "Metasploit::Model::Configuration::#{name.to_s.camelize}".constantize
        instance_variable_set child_class_instance_variable_name, child_class
      end

      child_class
    end
  end
end