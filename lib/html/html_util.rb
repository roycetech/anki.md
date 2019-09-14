module HtmlUtilDeprecated
  @@htmlcustom_words = nil

  def self.span(classname, text)
    "<span class=\"#{classname}\">#{text}</span>"
  end

  # "</span> <span>" will become </span>&nbsp;<span>
  def self.escape_spaces_between_angle!(string)
    re = />( *)</
    string.gsub!(re) { |token| '>' + '&nbsp;' * token[re, 1].length + '<' }
  end

  # Some spaces adjacent to tags need to be converted because it is not honored by
  # <pre> tag.
  def self.space_to_nbsp(input_string)
    pattern_between_tag = /> +</
    while pattern_between_tag =~ input_string
      lost_spaces = input_string[pattern_between_tag]
      input_string.sub!(pattern_between_tag, '>' + (HtmlBuilder::ESP * (lost_spaces.length - 2)) + '<')
    end

    pattern_before_tag = /^\s+</
    if pattern_before_tag.match?(input_string)
      lost_spaces = input_string[pattern_before_tag]
      input_string.sub!(pattern_before_tag, (HtmlBuilder::ESP * (lost_spaces.length - 1)) + '<')
    end
    input_string
  end # Will escape unknown tags only.

  def self.escape(input_string)
    return input_string if
      ['<div class="well"><code>', '</code></div>'].include? input_string.strip

    parser = SourceParser.new
    parser.regexter('inline code', /<code class="inline">/,
                    lambda { |token, _regexp|
                      token
                    })

    @@htmlcustom_words ||= get_html_keywords
    parser.regexter('known tags',
                    Regexp.new("<\\/?(?:#{@@htmlcustom_words.join('|')})>"),
                    lambda { |token, _regexp|
                      token
                    })

    parser.regexter('left angle',
                    %r{(<)(/?)(\w+)?},
                    lambda { |token, regexp|
                      "&lt;#{token[regexp, 2]}#{token[regexp, 3]}"
                    })

    parser.regexter('right angle',
                    /(\w+)?(>)/,
                    lambda { |token, regexp|
                      "#{token[regexp, 1]}&gt;"
                    })

    parser.parse(input_string)
  end
end

private

def get_html_keywords
  File.read('./data/keywords_customhtml.txt')
      .lines.collect(&:chomp)
end
