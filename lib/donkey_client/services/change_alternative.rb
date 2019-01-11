module DonkeyClient
  module Services
    class ChangeAlternative < Base
      attr_reader :experiment_slug, :alternative_slug, :anonymous_user_id, :user_id, :is_bot, :new_visitor

      def initialize(experiment_slug, alternative_slug, anonymous_user_id, user_id = nil, is_bot = false, new_visitor = false)
        @experiment_slug   = experiment_slug.to_s.strip
        @alternative_slug  = alternative_slug.to_s.strip
        @anonymous_user_id = anonymous_user_id
        @user_id           = user_id
        @is_bot            = is_bot
        @new_visitor       = new_visitor
      end

      def execute?
        !is_bot && experiment_slug.present? && alternative_slug.present? && anonymous_user_id.present?
      end

      def execute
        alternative_cache.fetch(overwrite: true) { data }
      rescue StandardError => exception
        Donkey.notify(exception) unless exception.is_a?(ActiveResource::TimeoutError)
      end

      private

      def alternative_cache
        @alternative_cache ||= ::Donkey::AlternativeCache.new(experiment_slug, anonymous_user_id, user_id)
      end

      def response
        @response ||= DonkeyClient::Resource::Alternative.post(:change, query_params)
      end

      def response_body
        JSON.parse(response.body)
      end

      def data
        @data ||= response_body.fetch('data')
      end

      def query_params
        {
          slug:              experiment_slug,
          alternative_slug:  alternative_slug,
          anonymous_user_id: anonymous_user_id,
          user_id:           user_id,
          new_visitor:       new_visitor
        }
      end
    end
  end
end
