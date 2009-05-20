

require 'bigdecimal'
require 'bigdecimal/math'
include BigMath

class Numeric
  #coerce to BigDecimal
  def b
    if self.is_a? BigDecimal
      self
    else
      BigDecimal.new(self.to_s)
    end
  end
end

class String
  #coerce to BigDecimal
  def b
    BigDecimal.new(self)
  end
end