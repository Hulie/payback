#
# Webgains Web Service
# http://ws.webgains.com/aws.php
#

module Payback
  module Networks
    class Webgains < Base

      required_credentials :username, :password

      attr_writer :read_timeout

      private

      def client
        @client ||= Savon.client(log_level: :info, read_timeout: read_timeout) do
          wsdl "http://ws.webgains.com/aws.php"
        end
      end

      def read_timeout
        @read_timeout || 300
      end

      def fetch(from, to)
        response = client.call(:get_full_earnings_with_currency,
          message: { username: username, password: password, startdate: from, enddate: to })
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
            timestamp: safe_extractor(node, 'date'),
            referrer: safe_extractor(node, 'referrer'),
            clicked_at: safe_extractor(node, 'clickthroughTime')
          )
        end
      end

    end
  end
end
