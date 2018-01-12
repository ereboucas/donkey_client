module Donkey
  class ExperimentContext
    attr_reader :user_id, :anonymous_user_id, :cache, :is_bot

    def initialize(user_id:, anonymous_user_id:, cache:, is_bot:)
      @user_id           = user_id
      @anonymous_user_id = anonymous_user_id
      @cache             = cache
      @is_bot            = is_bot
    end

    def participates_in?(experiment_slug, alternative_slug)
      assigned_alternative_slug = DonkeyClient::Services::AssignAlternative.execute(
        experiment_slug,
        anonymous_user_id,
        user_id,
        cache,
        is_bot
      )

      assigned_alternative_slug && assigned_alternative_slug == alternative_slug.to_s
    end

    def track!(metric_slug, performance_increase_value = 1.0)
      args    = [metric_slug, anonymous_user_id, performance_increase_value, user_id, is_bot]
      service = DonkeyClient::Services::Track

      service.respond_to?(:delay) ? service.delay.execute(*args) : service.execute(*args)
    end
  end
end
