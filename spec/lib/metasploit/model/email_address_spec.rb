require 'spec_helper'

describe Metasploit::Model::EmailAddress,
         # setting the metadata type makes rspec-rails include RSpec::Rails::ModelExampleGroup, which includes a better
         # be_valid matcher that will print full error messages
         type: :module  do
  it_should_behave_like 'Metasploit::Model::EmailAddress',
                        namespace_name: 'Dummy' do
     def attribute_type(attribute)
      type_by_attribute = {
        domain: :string,
        full: :string,
        local: :string
      }

      type_by_attribute.fetch(attribute)
    end
  end
end