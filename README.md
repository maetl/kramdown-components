# Kramdown Components

Rewrite and capture sections of Markdown documents using HTML Custom Elements.

Useful for enhancing code blocks and formatted markup with more sophisticated controls while maintaining a clean separation of presentation and content. Extract content from custom elements.

## How it Works

Register new components for your documents. Use the custom elements as block level wrappers in your text markup. Mix and match HTML and Markdown syntax. Generate nested DOM trees from a single top level element.

This library is only responsible for converting HTML elements at compile time. To actually render and control the element lifecycle when your document is viewed in a browser, you will need to attach the appropriate JavaScript.

## Usage

To use the enhanced documents with components, create a `CustomDocument` instance. This supports  the same interface as the base `Kramdown::Document`.

```ruby
require "kramdown-components"

document = Kramdown::CustomDocument("# Title")

puts document.to_html
```

Document [configuration options](https://kramdown.gettalong.org/options.html) can be passed to the document constructor in the same way as `Kramdown::Document`.

```ruby
require "kramdown-parser-gfm"
require "kramdown-components"

document = Kramdown::CustomDocument(File.read("README.md"), {
  input: "GFM",
  syntax_highlighter: "rouge"
)

puts document.to_html
```

### Registering Components

To define a custom element that can wrap child elements with the Markdown document, use the `define_element` class method to set the tag name.

```ruby
Kramdown::CustomDocument.define_element("wrapped-block")
```

You can customise the behaviour of components by extending `CustomElement` and binding the class to the tag name.

```ruby
class ImageGallery < Kramdown::CustomElement; end

Kramdown::CustomDocument.define_element("image-gallery", ImageGallery)
```

### Rewriting the DOM

To rewrite DOM subtrees wrapped by the component, implement the `parse_dom` method of `CustomElement` and manipulate the internal `root` and `children` elements, with instances of `Kramdown::Element` to represent each node.

```ruby
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
```

When this `#parse_dom` hook is applied, all child lists nested within the `<button-list>` component get rewritten to have the content of each list item wrapped in a `<button>`.

**Source:**

```md
<button-list>

- One
- Two
- Three

</button-list>
```

**Result:**

```html
<button-list id="bl-uftcpsbnzytd">
  <ul>
    <li><button>One</button></li>
    <li><button>Two</button></li>
    <li><button>Three</button></li>
  </ul>
</button-list>
```

## Extracting Content from the DOM

It’s also possible to use `#parse_dom` to extract content from the document, with or without rewriting.

```ruby
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
```

**Source:**

```md
Using the [HoneyGB palette](https://lospec.com/palette-list/honeygb):

<color-swatch>

- `#3e3a42`
- `#877286`
- `#f0b695`
- `#e9f5da`

</color-swatch>
```

**Result:**

```ruby
document = Kramdown::CustomDocument(source)

# Get a reference to the parsed `ColorSwatch` instance
color_swatch = document.custom_elements.first

# Use the custom `#to_a` method to get the first extracted color
color = color_swatch.to_a.first

# Render the color value as an RGB string
color.to_css
```
