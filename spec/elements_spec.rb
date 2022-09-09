require "spec_helper"

describe Kramdown::CustomDocument do
  it "matches multiple registered elements" do
    document = Kramdown::CustomDocument.new(read_fixture("elements.md"))

    expect(document.custom_elements.count).to be 2
    expect(document.to_html).to include("<wrapped-block").twice
    expect(document.to_html).to include("<raw-list").once
  end

  it "converts wrapped markup in registered elements" do
    document = Kramdown::CustomDocument.new(read_fixture("elements.md"))

    expect(document.to_html).to include("<li>First</li>")
    expect(document.to_html).to include("<li>Second</li>")
    expect(document.to_html).to include("<li>Third</li>")
  end

  it "passes through raw markup in unregistered elements" do
    document = Kramdown::CustomDocument.new(read_fixture("elements.md"))

    expect(document.to_html).to include("- First")
    expect(document.to_html).to include("- Second")
    expect(document.to_html).to include("- Third")
  end
end
