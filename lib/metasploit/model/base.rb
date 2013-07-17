# Superclass for all Metasploit::Models.  Just adds a default {#initialize} to make models mimic behavior of
# ActiveRecord::Base subclasses.
class Metasploit::Model::Base
  # @param attributes [Hash{Symbol => String,nil}]
  def initialize(attributes={})
    attributes.each do |attribute, value|
      public_send("#{attribute}=", value)
    end
  end
end