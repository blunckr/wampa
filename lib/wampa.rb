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

    private

    def new_resource_class(resource_name)
      Class.new do
        include Wampa::Resource
        @collection = {}
        const_set 'RESOURCE_NAME', resource_name
        const_set 'FIELDS', fields

        self::FIELDS.each do |field|
          attr_reader field
        end

        def id
          @id ||= url.match(/(\d+)\/$/).captures[0]
        end
      end
    end

    def resources_list
      path = 'data/resources.yml'
      return {} unless File.file? path
      YAML.load(File.read(path)).keys
    end
  end

  RESOURCES = resources_list

  RESOURCES.each do |resource_name|
    const_set resource_name.capitalize, new_resource_class(resource_name)
  end
end
