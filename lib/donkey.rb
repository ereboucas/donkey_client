require 'active_support'
require 'active_job'
require_relative 'donkey/settings'
require_relative 'donkey/experiment_context'
require_relative 'donkey/has_experiment_context'
require_relative 'donkey/cache'
require_relative 'donkey/alternative_cache'

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

  def self.cache
    Settings.table[:cache] ? Cache : NullCache
  end

  def self.always_control_group
    Settings.table[:always_control_group]
  end

  def self.worker_queue
    Settings.table[:worker_queue] || :default
  end

  def self.priority_worker_queue
    Settings.table[:priority_worker_queue] || worker_queue
  end
end
