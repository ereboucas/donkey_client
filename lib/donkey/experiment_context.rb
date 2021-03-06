module Donkey
  class ExperimentContext
    attr_reader :user_id, :anonymous_user_id, :cache, :is_bot, :new_visitor

    def initialize(user_id:, anonymous_user_id:, cache:, is_bot:, new_visitor:)
      @user_id           = user_id
      @anonymous_user_id = anonymous_user_id
      @cache             = cache
      @is_bot            = is_bot
      @new_visitor       = new_visitor
    end

    def participates_in?(experiment_slug, alternative_slug)
      assigned_alternative_slug = participate(experiment_slug)

      assigned_alternative_slug && assigned_alternative_slug == alternative_slug.to_s
    end

    def participate(experiment_slug)
      DonkeyClient::Services::AssignAlternative.execute(
        experiment_slug,
        anonymous_user_id,
        user_id,
        cache,
        is_bot,
        new_visitor
      )
    end

    def reparticipate(experiment_slug, alternative_slug)
      DonkeyClient::ServiceWorkers::ChangeAlternative.perform_later(
        experiment_slug.to_s,
        alternative_slug.to_s,
        anonymous_user_id,
        user_id,
        is_bot,
        new_visitor
      )
    end

    def track!(metric_slug, performance_increase_value = 1.0)
      return unless Donkey.configuration_data[:experiments].any?

      DonkeyClient::ServiceWorkers::Track.perform_later(
        metric_slug.to_s,
        anonymous_user_id,
        performance_increase_value,
        user_id,
        is_bot
      )
    end

    def reject(metric_slug)
      return unless Donkey.configuration_data[:experiments].any?

      DonkeyClient::ServiceWorkers::Reject.perform_later(
        metric_slug.to_s,
        anonymous_user_id,
        user_id,
        is_bot,
        Time.zone.now.to_s
      )
    end
  end
end
