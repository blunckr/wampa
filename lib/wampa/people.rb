class Wampa::People
  include Wampa::Resource
  @collection = [] # turn this into a hash when we have an id
  @schema = nil
  RESOURCE_NAME = 'people'
end
