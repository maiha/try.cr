require "./spec_helper"
require "xml"

private def parse(html : String)
  Try(XML::Node).try{ XML.parse_html(html) }
end

private def find(t_node, tag)
  t_node.map{|n| n.xpath_node("//#{tag}") || raise "#{tag} not found" }
end

private def text(t_node)
  t_node.map{|n| n.text || raise "text not found" }
end

private def find_text(html, tag)
  node = parse(html)
  span = find(node, tag)
  text(span)
end

private def valid_html
  <<-EOF
    <div>
      <span>foo</span>
      <span>bar</span>
    </div>
    EOF
end

private def broken_html
  <<-EOF
    <div>
      <sp
    EOF
end

private def empty_text_html
  <<-EOF
    <div/>
    EOF
end

describe "Example" do
  it "parse span from valid html" do
    text = find_text(valid_html, "span")
    text.get?.should eq("foo")
  end

  it "parse span from broken html" do
    text = find_text(broken_html, "span")
    text.get?.should eq(nil)
    text.failed.value.message.should eq("span not found")
  end

  it "parse span from empty text html" do
    text = find_text(empty_text_html, "span")
    text.get?.should eq(nil)
    text.failed.value.message.should eq("span not found")
  end
end
