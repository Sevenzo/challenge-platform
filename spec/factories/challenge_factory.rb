FactoryGirl.define do
  factory :challenge, class: Challenge do
    title 'The Test Challenge'
  end

  trait :with_panelists do
    transient do
      panelists nil
    end

    after :create do |challenge, evaluator|
      challenge.panel = Panel.new(users: evaluator.panelists)
    end
  end
end
