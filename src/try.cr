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
  abstract def failed : Try[Exception]
  abstract def foreach(&block : T -> U) : Nil
  abstract def map(&block : T -> U) : Try(U)
  abstract def recover(&block : Exception -> U) : Try(U)
end

class Success(T) < Try(T)
  getter :value

  def initialize(@value : T)
  end

  def success?
    true
  end
  
  def failure?
    false
  end
  
  def get
    @value
  end
  
  def get?
    @value
  end
  
  def failed
    Failure(Exception).new(Exception.new("can't cast #{@value.class} to Exception"))
  end
  
  def foreach(&block : T -> U)
    yield(@value)
  end

  def map(&block : T -> U) : Success(U) | Failure(U)
    Try(U).try { yield(@value) }
  end

  def recover(&block : Exception -> T)
    self
  end
end

class Failure(T) < Try(T)
  getter :value

  def initialize(@value : Exception)
  end

  def success?
    false
  end
  
  def failure?
    true
  end
  
  def failed
    Failure(Exception).new(@value)
  end

  def foreach(&block : T -> U)
    nil
  end

  def map(&block : T -> U) : Success(U) | Failure(U)
    Failure(U).new( @value )
  end

  def get
    raise @value
  end

  def get?
    nil
  end

  def recover(&block : Exception -> T)
    Try(T).try{ yield(@value) }
  end
end
