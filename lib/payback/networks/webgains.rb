#
# Webgains Web Service
# http://ws.webgains.com/aws.php
#

module Payback
  module Networks
    class Webgains < Base

      required_credentials :username, :password

      def client
        @client ||= Savon.client("http://ws.webgains.com/aws.php")
      end

      def fetch(from, to)
        response = client.request :get_full_earnings_with_currency do
          soap.body = {
            username: username,
            password: password,
            startdate: from,
            enddate: to
          }
        end
        parse(response.to_xml) if response.success?
      end

      def parse(payload)
        Nokogiri::XML(payload).css('item').map do |node|
          Conversion.new(
            program: safe_extractor(node, 'programName'),
            currency: safe_extractor(node, 'currency'),
            uid: safe_extractor(node, 'transactionID'),
            network: 'webgains',
            epi: safe_extractor(node, 'clickRef'),
            channel: safe_extractor(node, 'campaignName'),
            commission: safe_extractor(node, 'commission'),
            timestamp: safe_extractor(node, 'clickthroughTime')
          )
        end
      end

    end
  end
end
