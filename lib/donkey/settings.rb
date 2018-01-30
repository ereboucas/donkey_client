module Donkey
  module Settings
    @donkey_config = {}

    def self.table
      @donkey_config
    end

    def self.notifier(*args)
      @donkey_config[:notifier] = args
    end

    def self.cache(cache, options = {})
      @donkey_config[:cache] = cache
      @donkey_config[:cache_options] = options || {}
    end

    def self.always_control_group(arg)
      @donkey_config[:always_control_group] = arg
    end

    def self.always_control_group?
      @donkey_config[:always_control_group]
    end

    def self.configuration=(new_configuration_data)
      DonkeyClient::Resource::Configuration.create(data: new_configuration_data)
    rescue StandardError => error
      Donkey.notify(error)

      false
    ensure
      @donkey_config[:last_configuration] = new_configuration_data
    end
  end
end
