#
# Double API
# https://www.double.net/api/publisher/v2/
#

module Payback
  module Networks
    class Double < Base

      required_credentials :api_key

      URL = 'https://www.double.net/api/publisher/v2/events/'

      private

      def fetch(from, to)
        res = Excon.get(URL,
          query: {
            format: 'json',
            action__type__name: 'sale',
            start_date: from.strftime('%m/%d/%Y'),
            end_date: to.strftime('%m/%d/%Y')
          },
          headers: { 'Authorization' => "Token #{api_key}" }
        )
        parse(res.body)
      end

      def parse(payload)
        JSON.parse(payload).map do |item|
          Conversion.new(
            program: item['program_name'],
            currency: (item['commission'] || {})['credit_currency'],
            uid: item['id'],
            network: 'double',
            epi: item['epi'],
            channel: item['channel_name'],
            commission: (item['commission'] || {})['credit_amount'],
            timestamp: item['time'],
            status: item['status']
          )
        end
      end

    end
  end
end
