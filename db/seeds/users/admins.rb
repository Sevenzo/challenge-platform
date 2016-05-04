User.create!(
  email: ENV.fetch('ADMIN_EMAIL'),
  first_name: 'Admin',
  last_name: 'User',
  password: 'testing',
  role: 'Other',
  organization: ENV.fetch('COMPANY_NAME'),
  title: 'Admin',
  admin: true
)
