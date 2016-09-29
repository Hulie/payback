module Payback
  module Networks
    class PartnerAds < Base

      required_credentials :api_key

      URL = 'http://www.partner-ads.com/dk/vissalg_xml.php'

      private

      def endpoint
        @endpoint ||= begin
          uri = URI(URL)
          uri.query = URI.encode_www_form(key: api_key)
          uri.to_s
        end
      end

      def fetch(from, to)

        post_body = URI.encode_www_form(
          fra: from.strftime("%y-%m-%d"),
          til: to.strftime("%y-%m-%d")
        )

        res = Excon.post(endpoint,
          body: post_body,
          headers: { "Content-Type" => "application/x-www-form-urlencoded" })

        document = Nokogiri::XML(res.body)

        if document.errors.any?
          raise Payback::RequestError.new, res.body
        else
          parse(document)
        end

      end

      def parse(document)
        document.css('salg').map do |node|
          Conversion.new(
            program: safe_extractor(node, 'program'),
            currency: 'DKK',
            uid: safe_extractor(node, 'ordrenr'),
            network: 'partner_ads',
            epi: safe_extractor(node, 'uid'),
            commission: safe_extractor(node, 'provision'),
            timestamp: [node.at_css('dato'), node.at_css('tidspunkt')].join(' '),
            channel: parse_host(safe_extractor(node, 'url'))
          )
        end
      end

    end
  end
end
