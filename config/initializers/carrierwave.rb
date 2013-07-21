CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJIHY77FC7AQOFPRA',
      :aws_secret_access_key  => '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'
  }
  config.fog_directory = 'pulsefy'
end