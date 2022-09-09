class Color
  def self.from_hex(value)
    r, g, b = value.match(/^#(..)(..)(..)$/).captures.map(&:hex)
    new(r, g, b)
  end

  attr_reader :r, :g, :b

  def initialize(r, g, b)
    @r = r
    @g = g
    @b = b
  end

  def to_css
    "rgb(#{r}, #{g}, #{b})"
  end
end

class ColorSwatch < Kramdown::CustomElement
  def parse_dom(root)
    ul = root.children.find { |child_el| child_el.type == :ul }

    @colors = ul.children.map do |li|
      li.children.first.children.first.value
    end
  end

  def to_a
    @colors.map { |hex| Color.from_hex(hex) }
  end
end

Kramdown::CustomDocument.define_element("color-swatch", ColorSwatch)

describe Kramdown::CustomElement do
  it "extracts data from custom component" do
    document = Kramdown::CustomDocument.new(read_fixture("color-swatch.md"))

    color_swatch = document.custom_elements.first
    color_list = color_swatch.to_a

    expect(color_list.count).to be 4
    expect(color_list.first).to be_instance_of Color
    expect(color_list.last).to be_instance_of Color
    expect(color_list.first.to_css).to eq("rgb(62, 58, 66)")
  end
end
