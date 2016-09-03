require 'faker'

FactoryGirl.define do
  factory :user, class: User do
    password Faker::Internet.password(12)
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    avatar Faker::Avatar.image
    role 'FactoryGirl Role'
    title Faker::Name.title
    organization Faker::Company.name

    sequence :email do |n|
      "testname#{n}@example.com"
    end

    before(:create) { |user| user.display_name = "#{user.first_name} #{user.last_name[0]}" }
  end
  #
  # trait :with_small_avatar_file do
  #   after :create do | user |
  #     user.avatar = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/support/images/small_image.png'))
  #   end
  # end

end

