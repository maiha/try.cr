require "./spec_helper"

describe Try do
  it "contains success" do
    i = Try(Int32).try { 1 }

    i.success?.should eq(true)
    i.failure?.should eq(false)
    i.value.should eq(1)
  end

  it "captures failure" do
    i = Try(Int32).try { raise "error" }

    i.success?.should eq(false)
    i.failure?.should eq(true)
    i.value.should be_a(Exception)
  end

  describe "Success#map(T,U)" do
    it "maps the given function to the value" do
      i = Try(Int32).try { 1 }
      i.map{|v| v + 1}.value.should eq(2)
    end
  end

  describe "Failure#map(T,U)" do
    it "rewrap value by Failure(U)" do
      i = Try(Int32).try { raise "error" }
      i.map{|v| v + 1}.value.should be_a(Exception)
    end
  end
end
