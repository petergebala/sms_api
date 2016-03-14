require "sms_api/version"
require "sms_api/connection"
require "sms_api/mappings"

module SmsApi
  # SmsApi account credentials
  mattr_accessor :username
  mattr_accessor :password

  # Turn on/off testmode
  mattr_accessor :test_mode
  @@test_mode = false

  # Address of smsapi.pl
  mattr_accessor :api_url
  @@api_url = "https://ssl.smsapi.pl/sms.do"


  # Needed for configuration file
  def self.setup
    yield self
  end
end
