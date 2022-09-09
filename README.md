# Kramdown Components

Rewrite sections of Markdown documents using HTML Custom Elements.

Useful for enhancing code blocks and formatted markup with more sophisticated controls while maintaining a clean separation of presentation and content.

## How it Works

Register new components for your documents. Use the custom elements as block level wrappers in your text markup. Mix and match HTML and Markdown syntax. Generate nested DOM trees from a single top level element.

This library is only responsible for converting HTML elements at compile time. To actually render and control the element lifecycle when your document is viewed in a browser, you will need to attach the appropriate JavaScript.

## Usage

To use the enhanced documents with components, create a `CustomDocument` instance. This supports  the same interface as the base `Kramdown::Document`.

```ruby
require "kramdown-components"

doc = Kramdown::CustomDocument("# Title")

puts doc.to_html
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

### DOM Rewriting

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

When the `ButtonList#parse_dom` rewrite is applied, all child lists nested within the `<button-list>` component to have the content of each list item wrapped in a `<button>`.

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
