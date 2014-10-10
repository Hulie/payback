#
# Adrecord Publisher API
# https://api.adrecord.com/publisher/docs.html
#

module Payback
  module Networks
    class Adrecord < Base

      required_credentials :api_key

      HOST = 'https://api.adrecord.com'
      PATH = '/v1/transactions'

      def fetch(from, to)
        conn = Excon.new(HOST)
        res = conn.get(
          path: PATH,
          query: { start: from, stop: to },
          headers: { 'Apikey' => api_key }
        )
        parse(res.body)
      end

      def parse(payload)
        JSON.parse(payload)['result'].map do |item|
          Conversion.new(
            uid: item['id'],
            channel: URI::parse(item['channel']['url']).host.downcase,
            epi: item['epi'],
            timestamp: item['click'],
            commission: item['commission'].to_f / 100,
            currency: 'SEK',
            network: 'adrecord',
            program: item['program']['name'],
            status: item['status']
          )
        end
      end

    end
  end
end
