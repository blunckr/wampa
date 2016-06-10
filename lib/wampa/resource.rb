module Wampa::Resource
  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(attrs)
    attrs.each do |name, attr|
      instance_variable_set "@#{name}", attr
    end
  end

  module ClassMethods
    def find(id)
      resource_hash = Wampa.make_request("#{self::RESOURCE_NAME}/#{id}/")
      resource = self.new resource_hash
      @collection[resource.id] = resource
      resource
    end

    def find_all

    end

    private

    def fields
      schema_data = YAML.load(File.read("data/#{self::RESOURCE_NAME}.yml"))
      schema_data['properties'].keys
    end
  end
end
