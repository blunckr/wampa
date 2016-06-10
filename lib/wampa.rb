require "wampa/resource"
require "wampa/people"
require "wampa/version"

require "json"
require "yaml"
require 'pry'
module Wampa
  class << self
    def make_request(api_path=nil)
      uri = URI("http://swapi.co/api/#{api_path}")
      result = Net::HTTP.get(uri)
      JSON.parse result
    end

    def resources_schema
      @resources_schema ||= begin
        path = 'data/resources.yml'
        return {} unless File.file? path
        YAML.load(File.read(path))
      end
    end
  end

  RESOURCES = resources_schema.keys
end
