#
# NetBooster API
# https://campaigns.netboosteraffiliate.com/Api/Help
#

module Payback
  module Networks
    class Netbooster < Base

      required_credentials :api_key

      URL = 'https://campaigns.netboosteraffiliate.com/api'

      private

      # NOTE: dateFrom and dateTo must be in the same month
      def fetch(from, to)
        conversions = []
        (from..to).group_by { |x| [x.year, x.month].join('-') }.each do |month, dates|
          conversions.concat fetch_between(dates.min, dates.max)
        end
        conversions
      end

      def fetch_between(start, stop)

        data = get_request('Conversion',
          dateFrom: start.strftime("%Y-%m-%d"),
          dateTo: stop.strftime("%Y-%m-%d")
        )

        if data.is_a?(Hash) && data['Message']
          raise Payback::RequestError.new, data['Message']
        else
          parse(data)
        end

      end

      def get_request(command, params = {})
        endpoint = [URL, api_key, command].join('/')
        res = Excon.get(endpoint, query: params)
        data = JSON.parse(res.body)
      end

      def parse(data)
        data.map do |item|
          Conversion.new(
            program: item['Name'],
            currency: item['PayoutCurrency'],
            uid: item['ConversionId'],
            network: 'netbooster',
            epi: item['ProviderInformation']['subid1'],
            channel: nil,
            commission: item['Payout'],
            timestamp: item['ConversionDatetime'],
            clicked_at: item['ClickDatetime'],
            status: item['Status']
          )
        end
      end

    end
  end
end
