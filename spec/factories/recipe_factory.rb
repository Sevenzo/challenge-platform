FactoryGirl.define do
  factory :recipe, class: Recipe do
    title 'This is an recipe title from FactoryGirl.'
    description 'This is a recipe from FactoryGirl.'
  end

  trait :with_sequential_steps do
    after :create do |recipe|
      recipe.steps = create_list(:step, 6, :with_order)
    end
  end
end
