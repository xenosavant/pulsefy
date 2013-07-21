CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJIHY77FC7AQOFPRA',
      :aws_secret_access_key  => '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',
      :endpoint =>  's3-us-west-2.amazonaws.com'
  }
  config.fog_directory = 'pulsefy'
end