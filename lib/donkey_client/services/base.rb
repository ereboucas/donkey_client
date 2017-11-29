module DonkeyClient
  module Services
    class ImplementationError < StandardError; end

    class Base
      def self.execute(*args)
        service = new(*args)

        service.execute if service.execute?
      end

      def execute
        raise ImplementationError, 'Missing #execute method definition'
      end

      def execute?
        true
      end
    end
  end
end
