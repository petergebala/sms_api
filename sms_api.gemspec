# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sms_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Piotr Gębala"]
  gem.email         = ["piotrek.gebala@gmial.com"]
  gem.description   = %q{Library for sending sms via smsapi.pl}
  gem.summary       = %q{v0.1 supports only sending sms}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sms_api"
  gem.require_paths = ["lib"]
  gem.version       = SmsApi::VERSION
end
