module Payback
  module Networks
    class Targetcircle < Base

      required_credentials :api_key

      URL = 'https://api.targetcircle.com/api/v1/transactions'

      private

      def fetch(from, to)
        conn = Excon.new(URL)
        res = conn.get(
          query: {
            savedFrom: from,
            savedTo: to },
          headers: { 'X-Api-Token' => api_key }
        )

        body = JSON.parse(res.body)
        if body.is_a?(Hash) && body['detail']
          raise Payback::RequestError.new, body['detail']
        else
          parse(body['data'])
        end
      end

      def parse(data)
        data.map do |item|
          Conversion.new(
            program: item['offer'],
            epi: (item['reference'] || {})['ref1'],
            currency: item['currency'],
            uid: item['transactionId'],
            network: 'targetcircle',
            commission: item['payout'],
            timestamp: item['saved'],
            status: item['status'],
            clicked_at: item['clickSaved']
          )
        end
      end

    end
  end
end
