RSpec::Matchers.define :support do |attribute|
  description do
    "support #{attribute}"
  end

  failure_message_for_should do |module_instance|
    "expected that #{module_instance} would support #{attribute}"
  end

  failure_message_for_should_not do |module_instance|
    "expected that #{module_instance} would not support #{attribute}"
  end

  match do |module_instance|
    module_instance.supports?(attribute)
  end
end