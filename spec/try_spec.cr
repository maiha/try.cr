require "./spec_helper"

private class TryError < Exception
  def_equals message
end

private def error(msg = "error")
  TryError.new(msg)
end

private def success
  Try(Int32).try { 1 }
end

private def failure
  Try(Int32).try { raise error }
end

describe Try do
  describe ".try" do
    it "wraps success as Success" do
      i = Try(Int32).try { 1 }
      i.should be_a(Success(Int32))
    end

    it "captures failure as Failure" do
      i = Try(Int32).try { raise error }
      i.should be_a(Failure(Int32))
    end
  end

  describe ".sequence" do
    it "wraps success as Success" do
      i = Try(Int32).sequence {
        [ Try(Int32).try { 1 },Try(Int32).try { 2 },Try(Int32).try { 3 }]
      }
      i.should be_a(Success(Enumerable(Int32)))
      i.get.should eq([1,2,3])
    end

    it "captures failure as Failure" do
      i = Try(Int32).sequence {
        [ Try(Int32).try { 1 },Try(Int32).try { raise error },Try(Int32).try { 3 }]
      }
      i.should be_a(Failure(Enumerable(Int32)))
    end
  end

  describe "#success?" do
    it "returns true [Success]" do
      success.success?.should be_true
    end

    it "returns false [Failure]" do
      failure.success?.should be_false
    end
  end

  describe "#failure?" do
    it "returns false [Success]" do
      success.failure?.should be_false
    end

    it "returns true [Failure]" do
      failure.failure?.should be_true
    end
  end

  describe "#get" do
    it "returns the value [Success]" do
      success.get.should eq(1)
    end

    it "raises the exception [Failure]" do
      expect_raises(TryError) {
        failure.get
      }
    end
  end

  describe "#get?" do
    it "returns the value [Success]" do
      success.get?.should eq(1)
    end

    it "returns nil [Failure]" do
      failure.get?.should eq(nil)
    end
  end

  describe "#err" do
    it "raises the exception [Success]" do
      expect_raises(Exception) {
        success.err
      }
    end

    it "returns the exception [Failure]" do
      failure.err.should be_a(TryError)
    end
  end

  describe "#err?" do
    it "returns nil [Success]" do
      success.err?.should eq(nil)
    end

    it "returns the exception [Failure]" do
      failure.err.should be_a(TryError)
    end
  end

  describe "#value" do
    it "returns the value [Success]" do
      success.value.should eq(1)
    end

    it "raises the exception [Failure]" do
      failure.value.should eq(error)
    end
  end

  describe "#foreach" do
    it "yield with the value [Success]" do
      got = nil
      success.foreach{|v| got = v}
      got.should eq(success.get)
    end

    it "nop [Failure]" do
      got = nil
      failure.foreach{|v| got = v}
      got.should eq(nil)
    end
  end

  describe "#map(T,U)" do
    it "maps the given function to the value [Success]" do
      success.map(&.+ 1).value.should eq(2)
    end

    it "rewrap value by Failure(U) [Failure]" do
      failure.map(&.+ 1).value.should be_a(Exception)
    end
  end

  describe "#flat_map(T,U)" do
    it "maps the given function to the value [Success]" do
      success.flat_map{|v| Try(Int32).try{ v + 1 }}.value.should eq(2)
    end

    it "rewrap value by Failure(U) [Failure]" do
      failure.flat_map{|v| Try(Int32).try{ v + 1 }}.value.should be_a(Exception)
    end
  end

  describe "#recover" do
    it "returns self [Success]" do
      t = success
      t.recover{|e| 0}.should eq(t)
    end

    describe "apply the given function to the error [Failure]" do
      it "returns Success when succeeded" do
        t = failure
        t.recover{|e| 0}.should eq(Success(Int32).new(0))
      end

      it "returns Failure when failed" do
        t = failure
        t.recover{|e| raise error("2nd error") }.should eq(Failure(Int32).new(error("2nd error")))
      end
    end
  end
end
