module DonkeyClient
  module Services
    class AssignAlternative < Base
      attr_reader :experiment_slug, :anonymous_user_id, :user_id

      def initialize(experiment_slug, anonymous_user_id, user_id = nil)
        @experiment_slug = experiment_slug.to_s.strip
        @anonymous_user_id = anonymous_user_id.to_s.strip
        @user_id = user_id.to_i.nonzero?
      end

      def execute?
        experiment_slug.present? && anonymous_user_id.present?
      end

      def execute
        data { control_group }
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

      def data
        cache = Donkey.cache.read(cache_key)

        return cache if cache.present?

        skip_caching? ? response_body.fetch('data') : Donkey.cache.write(cache_key, response_body.fetch('data'))
      end

      def query_params
        {
          slug: experiment_slug,
          anonymous_user_id: anonymous_user_id,
          user_id: user_id
        }
      end

      def cache_key
        @cache_key ||= "#{experiment_slug}/#{anonymous_user_id}/#{user_id}"
      end

      def skip_caching?
        response.code != '200' || response_body.fetch('data') == control_group
      end
    end
  end
end
