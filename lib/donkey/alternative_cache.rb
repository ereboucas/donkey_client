module Donkey
  class AlternativeCache
    attr_reader :experiment_slug, :anonymous_user_id, :user_id

    def initialize(experiment_slug, anonymous_user_id, user_id)
      @experiment_slug   = experiment_slug
      @anonymous_user_id = anonymous_user_id
      @user_id           = user_id
    end

    def fetch(overwrite: false, &block)
      overwrite ? write_alternative(&block) : read_alternative(&block)
    end

    private

    def read_alternative(&block)
      cache_value = Donkey.cache.read(cache_key)

      cache_value || write_alternative(&block)
    end

    def write_alternative
      yield.tap do |value|
        Donkey.cache.write(cache_key, value)
      end
    end

    def cache_key
      @cache_key ||= "donkey/#{experiment_slug}/#{anonymous_user_id}/#{user_id}"
    end
  end
end
