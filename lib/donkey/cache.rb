module Donkey
  module NullCache
    def self.write(*); end
    def self.read(*); end
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
