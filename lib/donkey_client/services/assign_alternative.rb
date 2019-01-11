module DonkeyClient
  module Services
    class AssignAlternative < Base
      attr_reader :experiment_slug, :anonymous_user_id, :user_id, :cache, :is_bot, :new_visitor

      def initialize(experiment_slug, anonymous_user_id, user_id = nil, cache = nil, is_bot, new_visitor)
        @experiment_slug   = experiment_slug.to_s.strip
        @anonymous_user_id = anonymous_user_id.to_s.strip
        @user_id           = user_id.to_i.nonzero?
        @cache             = cache
        @is_bot            = is_bot
        @new_visitor       = new_visitor
      end

      def execute?
        experiment_slug.present? && anonymous_user_id.present?
      end

      def execute
        is_bot || ::Donkey::Settings.always_control_group? ? control_group : alternative
      rescue StandardError => exception
        Donkey.notify(exception) unless exception.is_a?(ActiveResource::TimeoutError)

        control_group
      end

      private

      def alternative_cache
        @alternative_cache ||= ::Donkey::AlternativeCache.new(experiment_slug, anonymous_user_id, user_id)
      end

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
        return data unless cache

        alternative_cache.fetch { data }
      end

      def data
        @data ||= response_body.fetch('data')
      end

      def query_params
        {
          slug:              experiment_slug,
          anonymous_user_id: anonymous_user_id,
          user_id:           user_id,
          new_visitor:       new_visitor
        }
      end
    end
  end
end
