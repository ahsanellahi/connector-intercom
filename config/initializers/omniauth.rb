Rails.application.config.middleware.use OmniAuth::Builder do
  provider :intercom, ENV['intercom_api_key'], ENV['intercom_api_secret']
end
