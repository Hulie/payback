module Payback
  module Networks
    class Tradedoubler < Base

      required_credentials :api_key

      URL = 'http://login.tradedoubler.com/pan/aReport3Key.action'

      private

      def fetch(from, to)
        res = Excon.get(URL,
          query: {
            "reportName"                   => "aAffiliateEventBreakdownReport",
            "startDate"                    => from,
            "endDate"                      => to,
            "currencyId"                   => 'SEK',
            "format"                       => "XML",
            "key"                          => api_key
          }
        )
        parse(res.body)
      end

      def parse(payload)
        Nokogiri::XML(payload).css('row').map do |node|
          Conversion.new(
            program: safe_extractor(node, 'programName'),
            currency: nil,
            uid: build_uid(node),
            network: 'tradedoubler',
            epi: safe_extractor(node, 'epi1'),
            channel: safe_extractor(node, 'siteName'),
            commission: safe_extractor(node, 'affiliateCommission'),
            timestamp: safe_extractor(node, 'timeOfVisit')
          )
        end
      end

      def build_uid(node)
        order_id = safe_extractor(node, 'orderNR')
        lead_id = safe_extractor(node, 'leadNR')
        event_id = node.at_css('eventId')
        if type_id = [order_id, lead_id].reject { |c| c.empty? }.first
          [type_id, event_id].join('-')
        end
      end

    end
  end
end
