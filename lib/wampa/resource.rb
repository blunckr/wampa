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
      @collection << resource
      resource
    end

    def find_all

    end

    def schema
      @schema ||= Wampa.make_request("#{self::RESOURCE_NAME}/schema")
    end
  end
end
