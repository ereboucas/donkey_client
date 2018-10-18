module Donkey
  module ThreadCache
    def self.write(*args, &block)
      key, val = args

      hash_in_current_thread[key] = val
    end

    def self.read(*args, &block)
      key, _val = args

      hash_in_current_thread[key]
    end

    def self.clear
      Thread.current[:cache] = {}
    end

    def self.hash_in_current_thread
      Thread.current[:cache] ||= {}
    end
  end

  module NullCache
    def self.write(*); end
    def self.read(*); end
    def self.clear; end
  end

  module Cache
    def self.write(*args, &block)
      Settings.table[:cache].write(*args, **Settings.table[:cache_options].to_h, &block)
    end

    def self.read(*args, &block)
      Settings.table[:cache].read(*args, &block)
    end
  end
end
