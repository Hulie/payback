#
# AWIN Publisher API
# http://wiki.awin.com/index.php/Publisher_API
#
# Please note: the maximum date range between startDate and endDate currently supported is 31 days.

module Payback
  module Networks
    class Awin < Base

      required_credentials :api_key, :user_id

      HOST = 'https://api.awin.com/'
      DAYS_MAXIMUM = 31
      DAYS_MINIMUM = 1

      private

      def fetch(from, to)
        bulk = []
        (from..to).each_slice(DAYS_MAXIMUM) do |slice|
          if slice.size <= DAYS_MINIMUM
            bulk.concat fetch_between(slice.first, slice.first + DAYS_MINIMUM)
          else
            bulk.concat fetch_between(slice.first, slice.last)
          end
        end
        bulk
      end

      def fetch_between(from, to)

        conn = Excon.new(HOST)
        path = "/publishers/#{user_id}/transactions/"

        fromParam = from.strftime("%Y-%m-%dT00:00:00")
        toParam = to.strftime("%Y-%m-%dT23:59:59")
        
        res = conn.get(
          path: path,
          query: {
            startDate: fromParam,
            endDate: toParam,
            timezone: 'UTC',
            accessToken: api_key
          }
        )

        data = JSON.parse(res.body)

        if data.is_a?(Hash) && data.has_key?('error')
          raise Payback::RequestError.new, [data['error'], data['description']]
            .join(' => ')
        else
          parse(data)
        end

      end

      def parse(data)
        data.map do |item|
          Conversion.new(
            uid: item['id'],
            channel: item['siteName'],
            epi: item['clickRefs']['clickRef'],
            commission: item['commissionAmount']['amount'],
            currency: item['commissionAmount']['currency'],
            network: 'awin',
            program: item['advertiserId'],
            status: item['commissionStatus'],
            referrer: item['publisherUrl'],
            clicked_at: item['clickDate'],
            timestamp: item['transactionDate']
          )
        end
      end

    end
  end
end
