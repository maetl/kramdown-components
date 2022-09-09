module Kramdown
  # Base component to add additional compile time behaviour to custom elements
  # in Kramdown documents.
  class CustomElement
    attr_reader :id

    # @param [String] id
    def initialize(id)
      @id = id
    end

    # Abstract method hook for custom element parsing. Override this to
    # add custom DOM rewriting and content extraction behaviour.
    #
    # @abstract
    # @param [Kramdown::Element] root
    def parse_dom(root)
    end

    # @return [String]
    def inspect
      "<KD::CustomElement id=#{id}>"
    end
  end
end
