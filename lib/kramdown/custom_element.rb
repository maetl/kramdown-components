module Kramdown
  class CustomElement
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def parse_dom(root)
    end
  end
end
