#
# Adservice API
# https://publisher.adservice.com/doc/publisher/API/toc_index.html#top
#
# Generate a login token at
# https://publisher.adservice.com/cgi-bin/publisher/API/Account.pl/loginToken?pwd=yourPassword&login=yourUsername

module Payback
  module Networks
    class Adservice < Base

      required_credentials :user_id, :api_key

      HOST = 'https://publisher.adservice.com'
      PATH = '/cgi-bin/publisher/API/Statistics.pl/orders'

      private

      def auth_cookie
        "LoginToken=#{api_key}; UID=#{user_id};"
      end

      def fetch(from, to)
        conn = Excon.new(HOST)
        res = conn.get(
          path: PATH,
          query: { from_date: from, to_date: to, status: 'approve' },
          headers: { 'Cookie' => auth_cookie }
        )

        data = JSON.parse(res.body)
        parse(data)

      end

      def parse(data)
        data.fetch('rows', []).map do |item|
          Conversion.new(
            uid: item['record_id'],
            channel: item['medianame'],
            epi: item['sub'],
            commission: item['totalPay'],
            currency: item['currency_name'],
            network: 'adservice',
            program: item['camp_title'],
            status: item['status'],
            referrer: nil,
            clicked_at: item['cookie_stamp'],
            timestamp: item['stamp']
          )
        end
      end

    end
  end
end
