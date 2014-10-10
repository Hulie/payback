#
# Zanox Web Services
# http://wiki.zanox.com/en/Web_Services
#

require 'mechanize'
require 'base64'
require 'hmac-sha1'
require 'open-uri'

module Payback
  module Networks
    class Zanox < Base

      MAX_RETRIES = 10
      RETRY_INTERVAL = 2
      HOST = 'http://api.zanox.com'
      API_PATH = '/xml/2011-03-01'

      required_credentials :connect_id, :secret_key

      def fetch(from, to)
        (from..to).map do |date|
          fetch_by_date(date)
        end.flatten
      end

      def conn
        @conn ||= Excon.new(HOST)
      end

      def fetch_by_date(date)

        retry_count = 0

        begin

          http_verb = 'GET'
          uri = "/reports/sales/date/#{date}"

          timestamp = get_timestamp
          nonce = generate_nonce
          string2sign = http_verb + uri + timestamp + nonce

          signature = create_signature(secret_key, string2sign)

          # Authorization using querystring-parameters (Alternative to Authorization-Header)
          build_url = API_PATH + uri

          auth_header = "ZXWS" + " " + connect_id + ":" + signature

          res = conn.request(
            expects: [200],
            method: :get,
            path: build_url,
            headers: { 'Authorization' => auth_header,
              'Date' => timestamp, 'nonce' => nonce }
          )

          parse(res.body)

        rescue Mechanize::ResponseCodeError => e
          if (retry_count += 1) < MAX_RETRIES
            logger.info "zanox | (#{res.status}) Try %d/%d: still processing, retry in %d seconds..." %
              [retry_count, MAX_RETRIES, RETRY_INTERVAL*retry_count]
            sleep(RETRY_INTERVAL*retry_count)
            retry
          end
        end

      end

      def safe_extractor(node, selector)
        if node = node.at_css(selector)
          node.text
        end
      end

      def parse(payload)
        Nokogiri::XML(payload).css('saleItem').map do |node|
          Conversion.new(
            program: safe_extractor(node, 'program'),
            currency: safe_extractor(node, 'currency'),
            uid: node[:id],
            network: 'zanox',
            epi: safe_extractor(node, 'gpp#zpar0'),
            channel: safe_extractor(node, 'adspace'),
            commission: safe_extractor(node, 'commission'),
            timestamp: safe_extractor(node, 'clickDate')
          )
        end
      end

      def generate_nonce
        Digest::MD5.hexdigest((Time.new.usec + rand()).to_s)[0..19]
      end

      def get_timestamp
        Time.now.gmtime.strftime("%a, %d %b %Y %H:%M:%S GMT").to_s
      end

      def create_signature(secret_key, string2sign)
        Base64.encode64(HMAC::SHA1.new(secret_key).update(string2sign).digest)[0..-2]
      end

    end
  end
end
