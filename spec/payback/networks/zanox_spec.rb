require 'spec_helper'

describe Payback::Networks::Zanox do

  subject { Payback::Networks::Zanox }

  it "returns records" do
    VCR.use_cassette('zanox', tag: :zanox) do
      instance = subject.new
      records = instance.between('2014-10-11', '2014-10-12')
      records.first.tap do |record|
        record.uid.must_equal "123456"
        record.commission.must_equal 19.87
        record.epi.must_equal 'abc123'
        record.currency.must_equal 'SEK'
        record.network.must_equal 'zanox'
        record.channel.must_equal 'example.com'
        record.timestamp.must_equal Time.parse('2014-10-12T22:17:59.547+02:00')
        record.program.must_equal 'Kwik-E-Mart'
      end
    end
  end

end
