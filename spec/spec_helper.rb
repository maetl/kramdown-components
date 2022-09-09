$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "kramdown-components"

Kramdown::CustomDocument.define_element("wrapped-block")

def read_fixture(filename)
  File.read("./spec/fixtures/#{filename}")
end
