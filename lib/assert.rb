module Assert
  class AssertionError < StandardError
    def initialize(message: nil)
      @message = message
    end

    def error
      raise self, @message
    end
  end # end class

  def assert(expr, message: 'AssertionError')
    AssertionError.new(message: message).error unless expr
  end
end
