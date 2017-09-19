module Payback
  class Conversion

    ATTRIBUTES = %w(uid epi commission currency network
      channel program status timestamp referrer clicked_at)

    attr_accessor *ATTRIBUTES

    def initialize(attrs = {})
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def timestamp=(string)
      @timestamp = string ? Time.parse(string) : nil
    end

    def clicked_at=(string)
      @clicked_at = string ? Time.parse(string) : nil
    end

    def commission=(value)
      @commission = value ? value.to_f : nil
    end

    # TODO: Add GUID method?
    # def guid
    #   "#{network}-#{uid}"
    # end

    def attributes
      Hash[ATTRIBUTES.map { |key| [key, send(key)] }]
    end

  end
end
