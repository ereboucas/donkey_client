module Donkey
  module Settings
    @donkey_config = {}

    def self.table
      @donkey_config
    end

    def self.notifier(*args)
      @donkey_config[:notifier] = args
    end

    def self.preload_donkey_configuration_data!
      @donkey_config[:last_configuration] = DonkeyClient::Resource::Configuration.last.data.as_json
    rescue StandardError => error
      Donkey.notify(error)

      false
    end
  end
end
