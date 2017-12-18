module DonkeyClient
  module Services
    class AssignAlternative < Base
      attr_reader :experiment_slug, :anonymous_user_id, :user_id, :cache, :is_bot

      def initialize(experiment_slug, anonymous_user_id, user_id = nil, cache = nil, is_bot)
        @experiment_slug   = experiment_slug.to_s.strip
        @anonymous_user_id = anonymous_user_id.to_s.strip
        @user_id           = user_id.to_i.nonzero?
        @cache             = cache
        @is_bot            = is_bot
      end

      def execute?
        experiment_slug.present? && anonymous_user_id.present?
      end

      def execute
        is_bot ? control_group : alternative
      rescue ActiveResource::ConnectionError, Errno::ECONNREFUSED => exception
        Donkey.notify(exception)

        control_group
      end

      private

      def control_group
        Donkey.configuration_data.dig(
          :experiments,
          experiment_slug.to_sym,
          :control_group
        )
      end

      def response
        @response ||= DonkeyClient::Resource::Alternative.post(:assign, query_params)
      end

      def response_body
        JSON.parse(response.body)
      end

      def alternative
        cache = Donkey.cache.read(cache_key)

        return cache if cache.present?

        skip_caching? ? response_body.fetch('data') : Donkey.cache.write(cache_key, response_body.fetch('data'))
      end

      def query_params
        {
          slug:              experiment_slug,
          anonymous_user_id: anonymous_user_id,
          user_id:           user_id
        }
      end

      def cache_key
        @cache_key ||= "donkey/#{experiment_slug}/#{anonymous_user_id}/#{user_id}"
      end

      def skip_caching?
        !cache || response.code != '200'
      end
    end
  end
end
