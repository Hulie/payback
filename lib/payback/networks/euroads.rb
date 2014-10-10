module Payback
  module Networks
    class Euroads < Base

      required_credentials :api_key

      URL = 'http://www.euroads.se/system/api.php'

      def fetch(from, to)
        res = Excon.get(URL, query: {
          apikey: api_key,
          function: 'partner_campaign_downloadleads',
          campaignid: 'all',
          year: from.year,
          month: from.month,
          day: from.day,
          year1: to.year,
          month1: to.month,
          day1: to.day,
          format: 'text',
          version: 7
        })
        parse(res.body)
      end

      def parse(payload)
        CSV.parse(payload, col_sep: ';', headers: true).map do |row|
          Conversion.new(
            program: row['Campaigntitle'],
            currency: row['Currencysymbol'],
            uid: row['Unique-ID'],
            network: 'euroads',
            epi: row['PNI'],
            commission: row['Commission'],
            timestamp: row['TimeOfClick']
          )
        end
      end

    end
  end
end
