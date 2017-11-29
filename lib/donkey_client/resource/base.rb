module DonkeyClient
  module Resource
    class Base < ActiveResource::Base
      self.site = ENV['DONKEY_DASHBOARD_API_URL']
      self.format = :json
    end
  end
end
