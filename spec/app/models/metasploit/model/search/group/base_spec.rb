RSpec.describe Metasploit::Model::Search::Group::Base, type: :model do
  it { is_expected.to ensure_length_of(:children).is_at_least(1) }
end