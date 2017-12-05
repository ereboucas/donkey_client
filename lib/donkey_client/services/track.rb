module DonkeyClient
  module Services
    class Track < Base
      attr_reader :slug, :anonymous_user_id, :performance_increase_value, :user_id

      def initialize(slug, anonymous_user_id, performance_increase_value, user_id = nil)
        @slug = slug.to_s.strip
        @anonymous_user_id = anonymous_user_id.to_s.strip
        @performance_increase_value = performance_increase_value
        @user_id = user_id
      end

      def execute?
        slug.present? && anonymous_user_id.present?
      end

      def execute
        DonkeyClient::Resource::Metric.post(:track, query_params)
      rescue ActiveResource::ConnectionError, Errno::ECONNREFUSED => exception
        Donkey.notify(exception)

        false
      end

      private

      def query_params
        {
          slug: slug,
          anonymous_user_id: anonymous_user_id,
          performance_increase_value: performance_increase_value,
          user_id: user_id
        }
      end
    end
  end
end
