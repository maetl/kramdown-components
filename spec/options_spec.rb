require "spec_helper"

describe Kramdown::CustomDocument do
  it "parses Kramdown block elements" do
    document = Kramdown::CustomDocument.new(
      "# TOC\n\nUse custom elements in Markdown docs."
    )

    expect(document.to_html).to include("<h1 id=\"toc\">TOC</h1>")
    expect(document.to_html).to include("<p>Use custom elements in Markdown docs.</p>")
  end
end
