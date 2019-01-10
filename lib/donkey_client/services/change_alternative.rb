module DonkeyClient
  module Services
    class ChangeAlternative < Base
      attr_reader :experiment_slug, :alternative_slug, :donkey_context

      delegate :anonymous_user_id, :user_id, :is_bot, :new_visitor, to: :donkey_context

      def initialize(experiment_slug, alternative_slug, donkey_context)
        @experiment_slug  = experiment_slug.to_s.strip
        @alternative_slug = alternative_slug.to_s.strip
        @donkey_context   = donkey_context
      end

      def execute?
        !is_bot && experiment_slug.present? && alternative_slug.present? && anonymous_user_id.present?
      end

      def execute
        data
      rescue StandardError => exception
        Donkey.notify(exception) unless exception.is_a?(ActiveResource::TimeoutError)
      end

      private

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