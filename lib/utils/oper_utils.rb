# RTFC
module OperUtils
  # unit tested.
  def xor(expr1, expr2)
    expr1 && expr2 || !expr1 && !expr2 ? false : true
  end
end
