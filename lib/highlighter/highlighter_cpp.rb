class CppHighlighter < BaseHighlighter
  def keywords_file
    'keywords_cpp.txt'
  end

  def comment_marker
    '// '
  end

  def highlight_string(input_string)
    highlight_dblquoted(input_string)
  end
end # end of RubyHighlighter class
