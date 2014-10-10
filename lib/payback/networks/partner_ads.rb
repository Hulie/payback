module Payback
  module Networks
    class PartnerAds < Base

      required_credentials :api_key

      URL = 'http://www.partner-ads.com/dk/vissalg_xml.php'

      def fetch(from, to)
        res = Excon.post(URL, body: URI.encode_www_form(
          key: api_key,
          fra: from.strftime("%y-%m-%d"),
          til: to.strftime("%y-%m-%d")
        ), headers: { "Content-Type" => "application/x-www-form-urlencoded" })
        parse(res.body)
      end

      def safe_extractor(node, selector)
        if node = node.at_css(selector)
          node.text
        end
      end

      def parse(payload)
        Nokogiri::XML(payload).css('salg').map do |node|
          Conversion.new(
            program: safe_extractor(node, 'program'),
            currency: 'DKK',
            uid: safe_extractor(node, 'ordrenr'),
            network: 'partner_ads',
            epi: safe_extractor(node, 'uid'),
            commission: safe_extractor(node, 'provision'),
            timestamp: [node.at_css('dato'), node.at_css('tidspunkt')].join(' ')
          )
        end
      end

    end
  end
end
