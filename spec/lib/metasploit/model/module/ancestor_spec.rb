require 'spec_helper'

describe Metasploit::Model::Module::Ancestor do
  it_should_behave_like 'Metasploit::Model::Module::Ancestor',
                        namespace_name: 'Dummy'
end