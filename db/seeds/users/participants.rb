20.times do
  User.create!(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: 'testing',
    role: 'Other',
    organization: Faker::Company.name,
    title: Faker::Name.title,
    bio: Faker::Lorem.paragraph,
    avatar_option: 'upload',
    remote_avatar_url: Faker::Avatar.image
  )
end
