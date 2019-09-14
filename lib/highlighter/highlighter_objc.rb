require './lib/highlighter/base_highlighter'
require './lib/regextration_store'

class ObjCHighlighter < BaseHighlighter
  def keywords_file
    'keywords_objc.txt'
  end

  def comment_marker
    '// '
  end

  def highlight_string(input_string)
    highlight_quoted(input_string)
  end
end
