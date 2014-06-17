CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJH7L5BIM5BI6E3YA',
    :aws_secret_access_key  => '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'
  }
  config.fog_directory  = 'tmremondes'
  config.fog_public     = false  
#  config.fog_authenticated_url_expiration = 50
end