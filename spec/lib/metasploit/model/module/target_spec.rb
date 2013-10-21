require 'spec_helper'

describe Metasploit::Model::Module::Target,
         # setting the metadata type makes rspec-rails include RSpec::Rails::ModelExampleGroup, which includes a better
         # be_valid matcher that will print full error messages
         type: :module do
  it_should_behave_like 'Metasploit::Model::Module::Target',
                        namespace_name: 'Dummy'
end