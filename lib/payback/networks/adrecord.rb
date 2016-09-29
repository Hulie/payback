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

      private

      def fetch(from, to)
        conn = Excon.new(HOST)
        res = conn.get(
          path: PATH,
          query: { start: from, stop: to },
          headers: { 'Apikey' => api_key }
        )

        data = JSON.parse(res.body)

        if data['status'] == 'error'
          raise Payback::RequestError.new, data['message']
        else
          parse(data)
        end
      end

      def parse(data)
        data.fetch('result', []).map do |item|
          Conversion.new(
            uid: item['id'],
            channel: parse_host(item['channel']['url']),
            epi: item['epi'],
            commission: item['commission'].to_f / 100,
            currency: nil,
            network: 'adrecord',
            program: item['program']['name'],
            status: item['status'],
            timestamp: item['changes'].find do |obj|
              obj['type'] == 'transaction registered'
            end['date']
          )
        end
      end

    end
  end
end
