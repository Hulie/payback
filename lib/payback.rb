require "payback/version"
require 'payback/conversion'

require 'open-uri'
require 'base64'
require 'excon'
require 'json'
require 'csv'

module Payback

  def self.networks
    @@networks ||= {}
  end

  def self.register(network_klass)
    networks[network_klass.identifier] = network_klass
  end

end

require 'payback/networks'

def Payback(network_name, options = {})
  klass = Payback.networks.fetch(network_name.to_s) do |missing_name|
    raise "Network named #{missing_name} does not exist!"
  end
  klass.new(options)
end
