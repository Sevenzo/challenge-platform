FactoryGirl.define do
  factory :identity do
    user
    provider "MyString"
    uid "MyString"
  end
end
