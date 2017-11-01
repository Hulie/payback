require 'spec_helper'

describe Payback::Networks::Base do

  describe 'parse_host' do

    it "returns nil for bad URI" do
      instance = Payback::Networks::Base.new
      instance.parse_host(false).must_be_nil
    end

  end

end
