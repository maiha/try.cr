module Try(T)
  module Interface
    abstract def success? : Bool
    abstract def failure? : Bool
    abstract def get : T
    abstract def get? : T?
    abstract def failed : Failure(T)
    abstract def err : Exception
    abstract def err? : Exception?
    abstract def foreach(&block : T -> U) : Nil forall U
    abstract def map(&block : T -> U) : Failure(T) | Success(T) forall U
    abstract def flat_map(&block : T -> Failure(T) | Success(T)) : Failure(T) | Success(T) forall U
    abstract def recover(&block : Exception -> T) : Failure(T) | Success(T)
  end

  def self.try : Failure(T) | Success(T)
    Success(T).new(yield)
  rescue err
    Failure(T).new(err)
  end
end

class Success(T)
  def_equals value

  getter :value

  def initialize(@value : T)
  end

  def success? : Bool
    true
  end
  
  def failure? : Bool
    false
  end
  
  def get : T
    @value
  end
  
  def get? : T?
    @value
  end
  
  def err : Exception
    raise "not failed"
  end
  
  def err? : Exception?
    nil
  end
  
  def failed : Failure(T)
    Failure(T).new(Exception.new("can't cast #{@value.class} to Exception"))
  end
  
  def foreach(&block : T -> U) : Nil forall U
    yield(@value)
  end

  def map(&block : T -> U) : Failure(U) | Success(U) forall U
    Try(U).try { yield(@value) }
  end

  def flat_map(&block : T -> Failure(U) | Success(U)) : Failure(U) | Success(U) forall U
    Try(U).try { yield(@value).get }
  end

  def recover(&block : Exception -> T) : Failure(T) | Success(T)
    self
  end
end

class Failure(T)
  def_equals value

  getter value
  
  def initialize(@value : Exception)
  end

  def success? : Bool
    false
  end
  
  def failure? : Bool
    true
  end
  
  def get : T
    raise @value
  end

  def get? : T?
    nil
  end

  def err : Exception
    @value
  end
  
  def err? : Exception?
    @value
  end
  
  def failed : Failure(T)
    Failure(T).new(@value)
  end

  def foreach(&block : T -> U) : Nil forall U
    nil
  end

  def map(&block : T -> U) : Failure(U) | Success(U) forall U
    Failure(U).new( @value )
  end

  def flat_map(&block : T -> Failure(U) | Success(U)) : Failure(U) | Success(U) forall U
    Failure(U).new( @value )
  end

  def recover(&block : Exception -> T) : Failure(T) | Success(T)
    Try(T).try{ yield(@value) }
  end
end
