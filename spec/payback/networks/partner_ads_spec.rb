require 'spec_helper'

describe Payback::Networks::PartnerAds do

  subject { Payback::Networks::PartnerAds }

  it "returns records" do
    VCR.use_cassette('partner_ads', tag: :partner_ads) do
      instance = subject.new
      records = instance.between('2014-10-10', '2014-10-11')
      records.first.tap do |record|
        record.uid.must_equal "123456"
        record.commission.must_equal 19.87
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'DKK'
        record.network.must_equal 'partner_ads'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('10-10-2014 09:34:30')
        record.program.must_equal 'Kwik-E-Mart'
        record.clicked_at.must_equal nil
      end
    end
  end

end
