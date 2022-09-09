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

### Registration Phase

```rb

```

### Compile Phase
