CarrierWave.configure do |config|
  config.root = Dir.tmpdir
  config.cache_dir = 'carrierwave'

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage    =  :aws
    config.aws_acl    =  'public-read'
    config.aws_bucket =  ENV.fetch('AWS_S3_BUCKET')
    config.aws_credentials = {
      access_key_id:      ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key:  ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region:             ENV.fetch('AWS_REGION')
    }
  end
end
