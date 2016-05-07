FactoryGirl.define do
  factory :step, class: Step do
    description 'This is a test description from FactoryGirl.'
  end

  trait :with_order do
    sequence(:display_order) { |n| n }
  end
end
