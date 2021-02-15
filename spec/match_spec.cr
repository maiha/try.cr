require "./spec_helper"

describe "match" do
  it "TypeDeclaration of either [Success]" do
    try = Try(Int32).try { 1 }

    Try.match(try) {
      x : Success = x + 2
    }.should eq(3)

    Try.match(try) {
      x : Failure = x
    }.should eq(nil)
  end

  it "TypeDeclaration of either [Failure]" do
    try = Try(Int32).try { raise "foo" }

    Try.match(try) {
      x : Success = x + 2
    }.should eq(nil)

    Try.match(try) {
      x : Failure = x
    }.inspect.should eq("#<Exception:foo>")
  end

  it "Expression of either [Success]" do
    try = Try(Int32).try { 1 }

    Try.match(try) {
      x : Success
        x += 2
        x * 2
    }.should eq(6)

    Try.match(try) {
      x : Failure
        x
    }.should eq(nil)
  end

  it "Expression of either [Failure]" do
    try = Try(Int32).try { raise "foo" }

    Try.match(try) {
      x : Success
        x += 2
        x * 2
    }.should eq(nil)

    Try.match(try) {
      x : Failure
      x
    }.inspect.should eq("#<Exception:foo>")
  end

  it "Expression of both [Success]" do
    try = Try(Int32).try { 1 }

    Try.match(try) {
      x : Success = x + 2
      e : Failure = raise e
    }.should eq(3)

    Try.match(try) {
      x : Success
        x += 2
        x * 2
      e : Failure
        raise e
    }.should eq(6)
  end

  it "Expression of both [Failure]" do
    try = Try(Int32).try { raise "foo" }

    Try.match(try) {
      x : Success = x + 2
      e : Failure = e
    }.inspect.should eq("#<Exception:foo>")

    Try.match(try) {
      x : Success
        x += 2
        x * 2
      e : Failure
        e
    }.inspect.should eq("#<Exception:foo>")
  end
end
