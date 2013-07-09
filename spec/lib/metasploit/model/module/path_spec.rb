require 'spec_helper'

describe Metasploit::Model::Module::Path do
  subject(:path) do
    path_class.new
  end

  # Has to be tested with an ActiveModel since this gem doesn't use a database, but described_class should also work in
  # ActiveRecord.
  let(:path_class) do
    # capture for Class.new scope
    described_class = self.described_class

    Class.new do
      include described_class

      #
      # Attributes
      #

      # @!attribute [rw] gem
      #   The gem that owns this path.
      #
      #   @return [String, nil]
      attr_accessor :gem

      # @!attribute [rw] name
      #   The name of this path, scoped to {#gem}.
      #
      #   @return [String, nil]
      attr_accessor :name

      # @!attribute [rw] real_path
      #   Real (absolute) path on-disk.
      #
      #   @return [String]
      attr_accessor :real_path

      #
      # Methods
      #

      # @param attributes [Hash{Symbol => String,nil}]
      # @option attributes [String, nil] :gem The gem that owns this path.
      # @option attributes [Stirng, nil] :name The name of this path, scoped to :gem.
      def initialize(attributes={})
        attributes.each do |attribute, value|
          public_send("#{attribute}=", value)
        end
      end

      # Returns module name for error reporting
      #
      # @return [ActiveModel::Name]
      define_singleton_method(:model_name) do
        ActiveModel::Name.new(self, described_class, 'BaseClass')
      end
    end
  end

  it_should_behave_like 'Metasploit::Model::Module::Path'
end