module Wampa::Resource
  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(attrs)
    attrs.each do |name, attr|
      instance_variable_set "@#{name}", attr
    end
    self.class.collection[id] = self
  end

  def id
    @id ||= extract_id_from_path(url)
  end

  private

  def extract_id_from_path(path)
    path.scan(/(\d+)\/$/)[0][0]
  end

  module ClassMethods
    def find(id)
      resource = @collection[id.to_s]
      return resource if resource
      resource_hash = Wampa.make_request("#{self::RESOURCE_NAME}/#{id}/")
      resource = new resource_hash
      resource
    end

    def find_all(next_page = nil)
      response =
        if next_page
          Wampa.make_raw_request(next_page)
        else
          Wampa.make_request("#{self::RESOURCE_NAME}/")
        end
      response['results'].each do |resource|
        new resource
      end
      return if response['next'].nil?
      find_all response['next']
    end

    def collection
      @collection
    end

    private

    def fields
      schema_data = YAML.load(File.read("data/#{self::RESOURCE_NAME}.yml"))
      schema_data['properties'].keys
    end
  end
end
