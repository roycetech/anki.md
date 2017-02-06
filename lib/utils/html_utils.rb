require './lib/source_parser'

# Version 2.
module HtmlUtils
  BR = '<br>'.freeze

  # Escaped tokens
  ESP = '&nbsp;'.freeze
  ELT = '&lt;'.freeze
  EGT = '&gt;'.freeze

  # Wraps a text inside html tags, 'span' by default.
  def wrap(class_names, text, tag = :span)
    %(<#{tag} class="#{class_names}">#{text}</#{tag}>)
  end

  def escape_angles(input_string)
    input_string.gsub('<', ELT).gsub('>', EGT)
  end

  # Will change spaces starting a line, and in between >  and <, to &nbsp;
  def escape_spaces(input_string)
    parser = SourceParser.new
    func = ->(token, _regexp) { token.gsub(/[ ]/, ESP) }
    parser.regexter('starting spaces', /^\s+</, func)
    parser.regexter('spaces between tags', />\s+</, func)
    parser.parse(input_string)
  end

  def escape_spaces!(input_string)
    input_string.replace(escape_spaces(input_string))
  end
end
