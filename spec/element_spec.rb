require "spec_helper"

describe Kramdown::CustomDocument do
  it "extracts custom elements from registered components" do
    document = Kramdown::CustomDocument.new(read_fixture("element.md"))

    expect(document.custom_elements.count).to be 1
    expect(document.custom_elements.first).to be_instance_of Kramdown::CustomElement
  end

  it "generates DOM ids when not defined in the source" do
    document = Kramdown::CustomDocument.new(read_fixture("element.md"))

    expect(document.to_html).to include(
      "<wrapped-block id=\"#{document.custom_elements.first.id}\">"
    )
  end

  it "passes through DOM ids defined in the source" do
    document = Kramdown::CustomDocument.new(read_fixture("id.md"))

    expect(document.to_html).to include(
      "<wrapped-block id=\"dragons\">"
    )
  end
end
