#
# Commission Junction
# http://cjsupport.custhelp.com/app/answers/detail/a_id/1553
#

module Payback
  module Networks
    class Cj < Base

      required_credentials :api_key

      HOST = 'https://commission-detail.api.cj.com'
      PATH = '/v3/commissions'
      URL = HOST+PATH

      DAYS_MAXIMUM = 31
      DAYS_MINIMUM = 1

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

      def fetch_between(start, stop)
        params = {
          'date-type' => 'event',
          'start-date' => start,
          'end-date' => stop
        }
        querystring = URI.encode_www_form(params)
        res = open([URL, querystring].join('?'),
          { 'authorization' => api_key }
        )
        parse(res)
      end

      def parse(res)
        Nokogiri::XML(res.read).css('commission').map do |node|
          Conversion.new(
            program: safe_extractor(node, 'advertiser-name'),
            currency: nil, # Note: All currencies are reporting in your functional currency.
            uid: safe_extractor(node, 'commission-id'),
            network: 'cj',
            epi: safe_extractor(node, 'sid'),
            channel: safe_extractor(node, 'website-id'),
            commission: safe_extractor(node, 'commission-amount'),
            timestamp: safe_extractor(node, 'event-date')
          )
        end
      end

    end
  end
end
