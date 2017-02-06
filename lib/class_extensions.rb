# This file contains extensions to exisitng classes.
require './lib/utils/oop_utils'
require './lib/assert'

# Allow Regexp to be concatenated with +
class Regexp
  def +(other)
    Regexp.new(to_s + '|' + other.to_s)
  end
end

Object.class_eval { include Assert, OopUtils }
