#
# Tradetracker Web services
# https://affiliate.tradetracker.com/webService
#

module Payback
  module Networks
    class Tradetracker < Base

      required_credentials :user_id, :api_key

      URL = "http://ws.tradetracker.com/soap/affiliate?wsdl"

      private

      def fetch(from, to)
        get_affiliate_data.map do |channel_name, id|
          response = get_conversions(id, from, to)
          document = Nokogiri::XML(response.to_xml)
          document.css('item').map do |node|
            Conversion.new(
              program: safe_extractor(node, 'campaign > name'),
              currency: safe_extractor(node, 'currency'),
              uid: safe_extractor(node, 'ID'),
              network: 'tradetracker',
              epi: safe_extractor(node, 'reference'),
              channel: channel_name,
              commission: safe_extractor(node, 'commission'),
              timestamp: safe_extractor(node, 'registrationDate')
            )
          end
        end.flatten
      end

      private

        def client
          @client ||= Savon.client(wsdl: URL)
        end

        def auth_cookies
          @auth_cookies ||= authenticate
        end

        def authenticate
          response = client.call(:authenticate, message: {
            'customerID' => user_id,
            'passphrase' => api_key
          })
          response.http.cookies
        end

        def get_affiliate_data
          response = client.call(:get_affiliate_sites,
            message: { options: {} }, cookies: auth_cookies)
          Hash[*Nokogiri::XML(response.to_xml).css('item').map do |item|
            [item.at_css('name').text, item.at_css('ID').text]
          end.flatten]
        end

        def get_conversions(affiliate_id, from, to)
          response = client.call(:get_conversion_transactions, message: {
            options: { 'registrationDateFrom' => from, 'registrationDateTo' => to },
            'affiliateSiteID' => affiliate_id
          }, cookies: auth_cookies)
          response if response.success?
        end

    end
  end
end
