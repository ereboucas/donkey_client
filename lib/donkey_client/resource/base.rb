module DonkeyClient
  module Resource
    class Base < ActiveResource::Base
      self.site    = "#{ENV['DONKEY_URL'] || 'https://donkey.cgtr.io'}/api"
      self.timeout = 0.5
      self.format  = :json
    end
  end
end
