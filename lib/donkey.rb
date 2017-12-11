require 'active_support'
require_relative 'donkey/settings'
require_relative 'donkey/experiment_context'
require_relative 'donkey/has_experiment_context'

module Donkey
  def self.configurate
    yield(Settings)
  end

  def self.notify(exception)
    klass, method_name = *Array(Settings.table[:notifier])

    return unless klass && method_name
    klass.to_s.camelcase.constantize.public_send(method_name.to_sym, exception)
  end

  def self.configuration_data
    Settings.table[:last_configuration]&.deep_dup || {}
  end
end
