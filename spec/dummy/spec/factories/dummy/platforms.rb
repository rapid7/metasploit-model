FactoryGirl.define do
  sequence :dummy_platform, Dummy::Platform.all.cycle
end