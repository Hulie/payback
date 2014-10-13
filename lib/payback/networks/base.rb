require 'date'

module Payback
  module Networks
    class Base

      MissingCredentialsError = Class.new(StandardError)

      def initialize(options = {})
        options.each do |key, value|
          public_send("#{key}=", value)
        end
      end

      class << self

        def identifier
          self.to_s.gsub(/^.*::/, '').gsub(/(.)([A-Z])/,'\1_\2').downcase
        end

        def inherited(base)
          Payback.register(base)
        end

        attr_writer :credentials

        def credentials
          @credentials || []
        end

        def required_credentials(*keys)
          self.credentials = credentials.concat(keys)
          attr_writer *keys
          keys.each { |name| define_credentials_getter(name) }
        end

        def define_credentials_getter(name)
          define_method name do
            instance_variable_get("@#{name}") || load_from_env(name)
          end
        end

      end

      def since(days)
        from = (Date.today - days.pred)
        to = Date.today
        _fetch(from, to)
      end

      def between(from, to)
        from = parse_date(from)
        to = parse_date(to)
        _fetch(from, to)
      end

      def credentials
        @credentials ||= self.class.credentials
      end

      def valid_credentials?
        credentials.all? do |method_name|
          !public_send(method_name).nil?
        end
      end

      def logger
        @logger ||= Logger.new($stdout).tap do |x|
          x.progname = 'payback'
        end
      end

      def parse_date(value)
        case value
        when String then Date.parse(value)
        when Date then value
        else raise("Invalid date argument: #{value.inspect} (#{value.class})")
        end
      end

      def load_from_env(attr_name)
        variable_name = "#{self.class.identifier}_#{attr_name}".upcase
        ENV[variable_name]
      end

      def parse_host(url)
        if host = URI::parse(url).host
          host.downcase
        end
      end

      def safe_extractor(node, selector)
        if node = node.at_css(selector)
          node.text
        end
      end

      protected

      def _fetch(from, to)
        if valid_credentials?
          fetch(from, to)
        else
          error_msg = "Missing credentials for #{self.class}. Must supply " <<
          "#{credentials.join(', ')}"
          raise MissingCredentialsError, error_msg
        end
      end

      def fetch(from, to)
        raise NotImplementedError
      end

    end
  end
end
