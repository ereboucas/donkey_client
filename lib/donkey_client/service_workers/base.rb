module DonkeyClient
  module ServiceWorkers
    class Base < ::ActiveJob::Base
      queue_as { Donkey.worker_queue }

      def perform(*args, &block)
        service_class.execute(*args, &block)
      end

      private

      def service_class
        "DonkeyClient::Services::#{self.class.name.split('::').last}".constantize
      end
    end
  end
end
