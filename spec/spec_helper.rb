require 'payback'
require "minitest/autorun"
require "mocha"
require 'vcr'
require "minitest/reporters"
require 'webmock/minitest'

Minitest::Reporters.use!

VCR.configure do |c|

  # TODO: Force utf-8 to avoid binary
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end

  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock

  # Zanox requires random nonce for every request
  # and nonce is a part of the signature
  # http://wiki.zanox.com/en/User_Authentication
  zanox_uri = VCR.request_matchers.uri_without_param(:signature, :nonce, :date)
  c.register_request_matcher(:zanox_uri, &zanox_uri)

  # Hide all auth credentials in cassettes
  Payback.networks.each do |identifier, klass|
    klass.credentials.each do |name|
      var_name = "#{identifier}_#{name}".upcase
      c.filter_sensitive_data("<#{var_name}>", identifier.to_sym) { ENV[var_name] }
    end
  end

end
