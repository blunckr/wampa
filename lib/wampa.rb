require "wampa/resource"
require "wampa/people"
require "wampa/version"

require "json"

module Wampa
  class << self
    def make_request(api_path=nil)
      uri = URI("http://swapi.co/api/#{api_path}")
      Net::HTTP.get(uri)
    end

    def resource_list
      @resource_list ||= make_request
    end
  end
end
