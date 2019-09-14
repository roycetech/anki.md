class NoneHighlighter < BaseHighlighter
  # Suppress base class initialization, do not remove empty initializer
  def initialize
    super(HighlightersEnum::NONE)
  end

  # @Override.  /\A\z/ matches empty string only, not python compatible.
  def comment_regex
    /\A\z/
  end

  # @Override
  def string_regex
    /\A\z/
  end
end
