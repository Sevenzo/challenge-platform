FactoryGirl.define do
  factory :comment, class: Comment do
    user
    body 'This is a test comment from FactoryGirl.'
    association :commentable, factory: [:experience, :idea, :solution, :recipe, :suggestion, :cookbook].sample
  end
end

