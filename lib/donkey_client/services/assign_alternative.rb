module DonkeyClient
  module Services
    class AssignAlternative < Base
      attr_reader :slug, :anonymous_user_id, :user_id

      def initialize(slug, anonymous_user_id, user_id = nil)
        @slug = slug.to_s.strip
        @anonymous_user_id = anonymous_user_id.to_s.strip
        @user_id = user_id.to_i.nonzero?
      end

      def execute?
        slug.present? && anonymous_user_id.present?
      end

      def execute
        DonkeyClient::Resource::Alternative.post(:assign, query_params)
      rescue ActiveResource::ConnectionError, Errno::ECONNREFUSED => exception
        # log it? silently returns the exception object since all non :ok
        # responses are exceptions

        exception
      end

      private

      def query_params
        {
          slug: slug,
          anonymous_user_id: anonymous_user_id,
          user_id: user_id
        }
      end
    end
  end
end
