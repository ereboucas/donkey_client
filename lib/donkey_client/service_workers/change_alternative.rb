module DonkeyClient
  module ServiceWorkers
    class ChangeAlternative < Base
      queue_as { Donkey.priority_worker_queue }
    end
  end
end
