require "kramdown"

module Kramdown
  class CustomDocument
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

    def root
      @parsed_dom.root
    end

    def warnings
      @parsed_dom.warnings
    end

    def to_html
      @parsed_dom.to_html
    end

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
