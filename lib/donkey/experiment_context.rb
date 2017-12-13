module Donkey
  class ExperimentContext
    attr_reader :user_id, :anonymous_user_id

    def initialize(user_id:, anonymous_user_id:)
      @user_id           = user_id
      @anonymous_user_id = anonymous_user_id
    end

    def participates_in?(experiment_slug, alternative_slug)
      assigned_alternative_slug = DonkeyClient::Services::AssignAlternative.execute(
        experiment_slug,
        anonymous_user_id,
        user_id
      )

      assigned_alternative_slug && assigned_alternative_slug == alternative_slug.to_s
    end

    def track!(metric_slug, performance_increase_value = 1.0)
      DonkeyClient::Services::Track.execute(
        metric_slug,
        anonymous_user_id,
        performance_increase_value,
        user_id
      )
    end
  end
end
