#
class SwiftHighlighter < BaseHighlighter
  COLOR_CLASS_VAR = '#426F9C'.freeze

  def keywords_file
    'keywords_swift.txt'
  end

  def comment_marker
    '// '
  end

  def highlight_string(input_string)
    highlight_quoted(input_string)
  end

  def highlight_lang_specific(input_string)
    input_string
  end
end
