require "wampa/resource"
require "wampa/version"

require "json"
require "yaml"
require 'pry'
module Wampa
  class << self
    def make_request(api_path=nil)
      make_raw_request "http://swapi.co/api/#{api_path}"
    end

    def make_raw_request(path)
      uri = URI(path)
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
          if RESOURCES.include? field
            define_method "#{field}_ids" do
              instance_variable_get("@#{field}").map do |path|
                extract_id_from_path(path)
              end
            end

            define_method field do
              send("#{field}_ids").map do |resource_id|
                Wampa.const_get(field.capitalize).find(resource_id)
              end
            end
          else
            attr_reader field
          end
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
