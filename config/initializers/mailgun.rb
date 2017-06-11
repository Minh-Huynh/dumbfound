Mailgun.configure do |config|
  config.api_key = ENV['mailgun_secret_api_key']
end
