require "val"

abstract class Try(T)
  def_equals value

  def self.try
    Success(T).new(yield)
  rescue err
    Failure(T).new(err)
  end

  abstract def success? : Bool
  abstract def failure? : Bool
  abstract def value : T
  abstract def get : T
  abstract def get? : T?
  abstract def failed : Try(Exception)
  abstract def foreach(&block : T -> U) : Nil forall U
  abstract def map(&block : T -> U) : Try(U) forall U
  abstract def flat_map(&block : T -> Try(U)) : Try(U) forall U
  abstract def recover(&block : Exception -> T) : Try(T)
end

class Success(T) < Try(T)
  getter :value

  def initialize(@value : T)
  end

  val success?  = true
  val failure?  = false
  val get       = @value
  val get? : T? = @value
  
  def failed : Try(Exception)
    Failure(Exception).new(Exception.new("can't cast #{@value.class} to Exception"))
  end
  
  def foreach(&block : T -> U) : Nil forall U
    yield(@value)
  end

  def map(&block : T -> U) : Try(U) forall U
    Try(U).try { yield(@value) }
  end

  def flat_map(&block : T -> Try(U)) : Try(U) forall U
    Try(U).try { yield(@value).get }
  end

  def recover(&block : Exception -> T) : Try(T)
    self
  end
end

class Failure(T) < Try(T)
  getter :value

  def initialize(@value : Exception)
  end

  val success? = false
  val failure? = true

  def get : T
    raise @value
  end

  val get? : T? = nil

  def failed : Try(Exception)
    Failure(Exception).new(@value)
  end

  def foreach(&block : T -> U) : Nil forall U
    nil
  end

  def map(&block : T -> U) : Try(U) forall U
    Failure(U).new( @value )
  end

  def flat_map(&block : T -> Try(U)) : Try(U) forall U
    Failure(U).new( @value )
  end

  def recover(&block : Exception -> T) : Try(T)
    Try(T).try{ yield(@value) }
  end
end
