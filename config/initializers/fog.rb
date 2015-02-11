CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJIHY77FC7AQOFPRA',
      :aws_secret_access_key  => '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',
      :region => 'us-west-2'
  }
  config.fog_directory  = 'pulsefy'
  config.fog_public = false
end