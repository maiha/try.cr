class Try(T)
  def self.try : Success(T) | Failure(T)
    Success(T).new(yield)
  rescue err
    Failure(T).new(err)
  end
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
  
  def map(&block : T -> U) : Success(U) | Failure(U)
    Try(U).try { yield(@value) }
  end

  def recover(&block : Exception -> U)
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
  
  def map(&block : T -> U) : Success(U) | Failure(U)
    Failure(U).new( @value )
  end

  def get
    raise @value
  end

  def recover(&block : Exception -> U)
    yield
  end
end
