module Donkey
  module HasExperimentContext
    extend ActiveSupport::Concern

    included do
      helper_method :donkey
    end

    def donkey_experiment_context
      @donkey_experiment_context ||= ExperimentContext.new(
        user_id: send(@@user_method_name)&.id,
        anonymous_user_id: @@anonymous_user_id_method_name && send(@@anonymous_user_id_method_name)
      )
    end
    alias donkey donkey_experiment_context

    class_methods do
      def donkey_identity(user: nil, anonymous_user_id:)
        @@user_method_name = user
        @@anonymous_user_id_method_name = anonymous_user_id
      end
    end
  end
end
