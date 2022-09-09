class ButtonList < Kramdown::CustomElement
  def parse_dom(root)
    uls = root.children.filter { |child_el| child_el.type == :ul }
    uls.each do |ul|
      ul.children.each do |li|
        button = Kramdown::Element.new(:html_element, "button")
        button.children = li.children
        li.children = [button]
      end
    end
  end
end

Kramdown::CustomDocument.define_element("button-list", ButtonList)

describe Kramdown::CustomElement do
  it "rewrites DOM for custom component" do
    document = Kramdown::CustomDocument.new(read_fixture("button-list.md"))

    expect(document.to_html).to match(/<li>[\s]+<button>One<\/button>[\s]+<\/li>/)
    expect(document.to_html).to match(/<li>[\s]+<button>Two<\/button>[\s]+<\/li>/)
    expect(document.to_html).to match(/<li>[\s]+<button>Three<\/button>[\s]+<\/li>/)
  end
end
