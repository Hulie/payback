#
# Affiliator Publisher API
# http://www.affiliator.com/affiliate/api/docs/affiliator_publisher_api_v1.0_2014.pdf
#

module Payback
  module Networks
    class Affiliator < Base

      required_credentials :api_key, :username, :password

      VERSION = 'v1'
      URL = "https://api.affiliator.com/#{VERSION}/"

      def fetch(from, to)
        res = Excon.post(URL, body: URI.encode_www_form({
          showClickData: 'true',
          method: 'getSaleList',
          date_start: from,
          date_end: to,
          user: username,
          password: password,
          key: api_key,
          type: 'json'
        }), headers: { "Content-Type" => "application/x-www-form-urlencoded" })
        parse(res.body)
      end

      def parse(payload)
        JSON.parse(payload)['data']['sales'].map do |data|
          Conversion.new(
            program: data['program'],
            currency: data['currency'],
            uid: data['sale_id'],
            network: 'affiliator',
            epi: data['epi'],
            channel: parse_host(data['website']),
            commission: data['commission'],
            timestamp: [data['click_date'], data['click_time']].join(' '),
            status: data['status']
          )
        end
      end

    end
  end
end
