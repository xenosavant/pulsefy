if !Rails.env.production?
  require 'yaml'
  config = YAML.load_file(Rails.root.join("config", "services.yml"))
  ENV['AKIAJIHY77FC7AQOFPRA'] = config["s3"]["key"]
  ENV['hYC8+RrSaZSFcjK/JeM9EOmlKvYJ5CWfk/3tRNMx'] = config["s3"]["secret"]
  ENV['pulsefy'] = config["s3"]["bucket"]
end

CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJIHY77FC7AQOFPRA',
      :aws_secret_access_key  => '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',
      :region => 'us-west-2'
  }
  config.asset_host = 's3-us-west-2.amazonaws.com'
  config.fog_directory  = ENV['pulsefy']
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end