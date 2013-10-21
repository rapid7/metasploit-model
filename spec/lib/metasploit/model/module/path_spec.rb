require 'spec_helper'

describe Metasploit::Model::Module::Path do
  it_should_behave_like 'Metasploit::Model::Module::Path',
                        namespace_name: 'Dummy'
end