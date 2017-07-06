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

  def self.is_polish_phone_number?(number)
    phone_number = number.gsub(/\s|\-|\+|\.|\(|\)/, '')
    phone_number.length == 9 || (phone_number.length == 11 && phone_number.match(/^48/))
  end
end
