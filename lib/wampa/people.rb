class Wampa::People
  class << self
    def find(id)
      Wampa.make_request("people/#{id}")
    end
  end
end
