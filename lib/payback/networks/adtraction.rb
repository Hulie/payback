#
# Adtraction REST API
# https://api.adtraction.com/doc/
#

module Payback
  module Networks
    class Adtraction < Base

      required_credentials :api_key

      HOST = 'https://api.adtraction.com'
      PATH = '/v1/affiliate/transactions'

      private

      def fetch(from, to)
        conn = Excon.new(HOST)
        res = conn.post(
          path: PATH,
          body: JSON.dump({
            fromDate: date_to_utc(from),
            toDate: date_to_utc(to)
          }),
          headers: { 'X-Token' => api_key, 'Accept' => 'application/json',
            'Content-Type' => 'application/json' }
        )
        parse(res.body)
      end

      # TODO: Should support TimeZone.
      #       Example: 2014-06-12T13:54:51+0200
      def date_to_utc(date)
        date.to_datetime.strftime('%Y-%m-%dT%H:%M:%S%z')
      end

      def parse(payload)
        JSON.parse(payload).map do |item|
          Conversion.new(
            program: item['programName'],
            currency: item['currency'],
            uid: item['transactionId'],
            network: 'adtraction',
            epi: item['epi'],
            channel: item['channelName'],
            commission: item['commission'],
            timestamp: item['clickDate']
          )
        end
      end

    end
  end
end
