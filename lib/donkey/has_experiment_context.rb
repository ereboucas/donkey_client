module Donkey
  module HasExperimentContext
    extend ActiveSupport::Concern

    included do
      helper_method :donkey, :donkey_panel
    end

    def donkey_panel
      js_url = "#{(ENV['DONKEY_URL'] || 'https://donkey.cgtr.io')}/assets/integration.js"
      data   = { anonymous_user_id: donkey.anonymous_user_id }

      view_context.javascript_include_tag(js_url, async: true, defer: true, data: data)
    end

    def donkey_experiment_context
      @donkey_experiment_context ||= ExperimentContext.new(
        user_id:           send(@@user_method_name)&.id,
        anonymous_user_id: @@anonymous_user_id_method_name && send(@@anonymous_user_id_method_name),
        cache:             @@cache[send(@@user_method_name)],
        is_bot:            user_is_a_bot?,
        new_visitor:       @@new_visitor_method_name && send(@@new_visitor_method_name)
      )
    end
    alias donkey donkey_experiment_context

    class_methods do
      def donkey_identity(user: nil, anonymous_user_id:, cache:, new_visitor:)
        @@user_method_name              = user
        @@anonymous_user_id_method_name = anonymous_user_id
        @@new_visitor_method_name       = new_visitor
        @@cache                         = cache
      end
    end

    private

    def user_is_a_bot?
      Browser.new(request.user_agent).bot? || Browser.new(request.user_agent) == 'ELB-HealthChecker/1.0'
    end
  end
end
