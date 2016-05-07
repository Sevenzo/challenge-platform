FactoryGirl.define do
  factory :comment, class: Comment do
    user
    body 'This is a test comment from FactoryGirl.'
  end
end

