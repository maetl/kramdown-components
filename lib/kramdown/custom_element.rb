module Kramdown
  class CustomElement
    attr_reader :id, :outer_el

    def initialize(id, outer_el)
      @id = id
      @outer_el = outer_el
    end

    def parse_dom
    end
  end
end
