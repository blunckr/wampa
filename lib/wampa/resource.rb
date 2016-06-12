module Wampa::Resource
  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(attrs)
    attrs.each do |name, attr|
      instance_variable_set "@#{name}", attr
    end
  end

  def id
    @id ||= extract_id_from_path(url)
  end

  private

  def extract_id_from_path(path)
    path.match(/(\d+)\/$/).captures[0]
  end

  module ClassMethods
    def find(id)
      resource = @collection[id.to_s]
      return resource if resource
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
