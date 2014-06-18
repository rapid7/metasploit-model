FactoryGirl.define do
  factory :dummy_module_author, :class => Dummy::Module::Author do
    association :author, :factory => :dummy_author
    association :module_instance, :factory => :dummy_module_instance

    factory :full_dummy_module_author do
      association :email_address, :factory => :dummy_email_address
    end
  end
end
