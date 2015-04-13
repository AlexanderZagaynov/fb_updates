Koala.http_service.faraday_middleware = Proc.new do |builder|
  builder.use Faraday::Response::Logger
  Koala::HTTPService::DEFAULT_MIDDLEWARE.call(builder)
end

module Facebook
  APP_ID = ENV['FB_APP_ID'].to_s
  SECRET = ENV['FB_APP_SECRET'].to_s
  SVToken = SecureRandom.hex
end

Koala::Facebook::OAuth.class_eval do
  def initialize_with_default_settings(*args)
    case args.size
    when 0, 1
      raise "application id and/or secret are not specified in the config" unless Facebook::APP_ID && Facebook::SECRET
      initialize_without_default_settings(Facebook::APP_ID, Facebook::SECRET, args.first)
    when 2, 3
      initialize_without_default_settings(*args)
    end
  end
  alias_method_chain :initialize, :default_settings
end
