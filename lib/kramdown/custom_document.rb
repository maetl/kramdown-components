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

    attr_reader :custom_elements

    def initialize(source)
      @source = source
      @parsed_dom = Kramdown::Document.new(@source, {
        input: "GFM",
        parse_block_html: true,
        syntax_highlighter: "rouge"
      })
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

    def has_js?
      !@custom_elements.empty?
    end

    def to_js
      bundle = ["const EXAMPLE_HANDLERS = {}"]

      @custom_elements.each do |element|
        bundle << element.to_js
        bundle << "EXAMPLE_HANDLERS[\"#{element.id}\"] = #{element.name}"
      end

      bundle.join("\n\n")
    end

    def method_missing(id, *attr, &block)
      super
    end

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
          element = custom_element_cls.new(outer_el.attr["id"], outer_el)
          element.parse_dom

          # codeblocks = outer_el.children.filter { |child_el| child_el.type == :codeblock }
          #
          # outer_el.children = codeblocks.map do |codeblock|
          #   wrapper = Kramdown::Element.new(
          #     :html_element,
          #     "example-script",
          #     { label: LANG_LABELS[codeblock.options[:lang]] },
          #     { content_model: :block }
          #   )
          #   wrapper.children << codeblock
          #   wrapper
          # end
          #
          # outer_el.children.first.attr[:selected] = true

          elements << element
        end
      end

      elements
    end
  end
end
