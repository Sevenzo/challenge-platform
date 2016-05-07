FactoryGirl.define do
  factory :cookbook, class: Cookbook do
    sequence(:title) { |n| "Title ##{n}"}
    sequence(:description) { |n| "Description ##{n}"}
  end

  trait 'with_recipes' do

    transient do
      user nil
      amount 1
    end

    after :create do |cookbook, evaluator|
      cookbook.recipes = create_list(:recipe, evaluator.amount, user: evaluator.user)
    end
  end
end
