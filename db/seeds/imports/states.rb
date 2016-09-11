# This variable can be set to "small" to reduce the seed time
seed_task = 'small' if ['local', 'staging'].include?(ENV['DEPLOY_REMOTE'])

require 'csv'
require 'open-uri'

import_bucket = []
total_imported = 0

CSV.foreach(open("https://s3.amazonaws.com/pdc-dev-seeds/states.txt"), headers: true, col_sep: "\t", encoding: "ISO-8859-1") do |row|
  state = State.new
  import = row.to_hash

  state.fipst = import['FIPST']
  state.name = import['SEANAME'].titleize

  state.mail_street = import['STREET'].titleize
  state.mail_city = import['CITY'].titleize
  state.mail_state = import['STNAME']
  state.mail_zip = import['ZIP']
  state.mail_zip4 = import['ZIP4']
  state.phone = import['PHONE']

  state.number_of_members = import['MEMBER']

  import_bucket << state

  # We need these first 1000 schools or schools_spec test will fail
  if seed_task == 'small' && import_bucket.length >= 10
    puts "- finished small import"
    break
  end
end

State.transaction do
  import_bucket.each do |state|
    state.save!
    puts "-- Finished importing #{state.name}"
  end

  total_imported += import_bucket.length
end

puts "Finished importing #{total_imported} states"
