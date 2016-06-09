module Wampa::Resource
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def initialize(attrs)
      attrs.each do |name, attr|
        instance_variable_set "@#{name}", attr
      end
    end

  end

  module ClassMethods
    def find(id)
      response = Wampa.make_request("#{self::RESOURCE_NAME}/#{id}/")
      resource_hash = JSON.parse(response)
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
