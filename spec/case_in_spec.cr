require "./spec_helper"

# Make sure this compiles.
typeof(begin
  try = Try(Int32).try { 1 }
  case try
    in Failure(Int32)
    in Success(Int32)
  end
end)
