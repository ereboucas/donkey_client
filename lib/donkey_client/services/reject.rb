module DonkeyClient
  module Services
    class Reject < Base
      attr_reader :slug, :anonymous_user_id, :user_id, :is_bot, :occurred_at

      def initialize(slug, anonymous_user_id, user_id = nil, is_bot, occurred_at)
        @slug              = slug.to_s.strip
        @anonymous_user_id = anonymous_user_id.to_s.strip
        @user_id           = user_id
        @occurred_at       = occurred_at
        @is_bot            = is_bot
      end

      def execute?
        !is_bot && slug.present? && anonymous_user_id.present? && occurred_at.present?
      end

      def execute
        DonkeyClient::Resource::Metric.post(:reject, query_params)
      rescue ActiveResource::ConnectionError, Errno::ECONNREFUSED => exception
        Donkey.notify(exception) unless exception.is_a?(ActiveResource::TimeoutError)

        false
      end

      private

      def query_params
        {
          slug: slug,
          anonymous_user_id: anonymous_user_id,
          user_id: user_id,
          occurred_at: occurred_at
        }
      end
    end
  end
end
