require "wampa/resource"
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

    def new_resource_class(resource_name)
      Class.new do
        include Wampa::Resource
        @collection = [] # turn this into a hash when we have an id
        @schema = nil
        const_set 'RESOURCE_NAME', resource_name
      end
    end
  end

  RESOURCES = resources_schema.keys

  RESOURCES.each do |resource_name|
    const_set resource_name.capitalize, new_resource_class(resource_name)
  end
end

# class Wampa::People
#   include Wampa::Resource
#   @collection = [] # turn this into a hash when we have an id
#   @schema = nil
#   RESOURCE_NAME = 'people'
# end
