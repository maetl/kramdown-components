require "kramdown"

module Kramdown
  # An enhanced Kramdown document that supports embedded web components
  # with user-defined DOM parsing and rewriting behaviour.
  class CustomDocument
    # Define a custom element mapping for all document instances.
    # @param [String] name Tag name. Must conform to HTML Custom Element spec.
    # @param [Class] element CustomElement class to bind
    def self.define_element(name, element=nil)
      if element.nil?
        element = CustomElement
      end
      tag_name = name.downcase
      Kramdown::Parser::Html::Constants::HTML_ELEMENT[tag_name] = true
      Kramdown::Parser::Html::Constants::HTML_CONTENT_MODEL[tag_name] = :block
      @@custom_elements ||= {}
      @@custom_elements[tag_name] = element
    end

    DEFAULTS = {
      parse_block_html: true
    }

    attr_reader :custom_elements

    def initialize(source, options={})
      @source = source
      @parsed_dom = Kramdown::Document.new(@source, DEFAULTS.merge(options))
      @custom_elements = extract_custom_elements
    end

    # Configuration options hash.
    # @return [Hash]
    def options
      @parsed_dom.options
    end

    # The root of the element tree.
    # @return [Kramdown::Element]
    def root
      @parsed_dom.root
    end

    # An array of warning messages. Filled during the parsing and conversion
    # phases.
    # @return [Array]
    def warnings
      @parsed_dom.warnings
    end

    # @return [String]
    def inspect
      "<KD:CustomDocument:" \
        "options=#{options.inspect}" \
        "root=#{root.inspect}" \
        "warnings=#{warnings.inspect}" \
        "custom_elements=#{@custom_elements.inspect}>"
    end

    # Check if a method is invoked that begins with +to_+ and if so, try to
    # instantiate a converter.
    def method_missing(id, *attr, &block)
      @parsed_dom.send(id, attr, &block)
    end

    private

    def generate_el_id(tagname)
      alphabet = [('a'..'z')].map(&:to_a).flatten
      tag_id = (0...12).map { alphabet[rand(alphabet.length)] }.join
      tag_abbr = tagname.split("-").map { |part| part[0] }.join("")
      "#{tag_abbr}-#{tag_id}"
    end

    def extract_custom_elements
      elements = []

      @parsed_dom.root.children.each do |outer_el|
        if outer_el.type == :html_element && @@custom_elements.keys.include?(outer_el.value)

          unless outer_el.attr.key?("id")
            outer_el.attr["id"] = generate_el_id(outer_el.value)
          end

          custom_element_cls = @@custom_elements[outer_el.value]
          element = custom_element_cls.new(outer_el.attr["id"])
          element.parse_dom(outer_el)

          elements << element
        end
      end

      elements
    end
  end
end
