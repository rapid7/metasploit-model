FactoryGirl.define do
  factory :dummy_module_author, :class => Dummy::Module::Author do
    association :author, :factory => :dummy_author

    # @todo https://www.pivotaltracker.com/story/show/54632646

    factory :full_dummy_module_author do
      association :email_address, :factory => :dummy_email_address
    end
  end
end
