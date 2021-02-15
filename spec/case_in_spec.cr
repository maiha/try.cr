require "./spec_helper"

{% if ::Crystal::VERSION =~ /^0\.([12]\d|3[0-4])\./ %}
  # no case in features

{% else %}
  # Make sure this compiles.
  typeof(begin
    try = Try(Int32).try { 1 }
    case try
      in Failure(Int32)
      in Success(Int32)
    end
  end)
{% end %}
