# TODO: Outdated!!!
class JQueryHighlighter < BaseHighlighter
  def initialize
    super(HighlightersEnum::JQUERY)
  end

  def keywords_file
    'keywords_js.txt'
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.c.html.build
  end

  def string_regex
    RE_QUOTE_DOUBLE
  end

  def highlight_lang_specific(string_input)
    string_input.gsub!(%r{(\/\*[\d\D]\*\/)}, '<span class="comment">\1</span>')
    string_input
  end

  def highlight_all(string_input)
    re_jq = /\$\("(.+)"\)/
    if string_input[re_jq]
      string_input.gsub!(re_jq) do
        jq_inside = Regexp.last_match(1)

        if jq_inside[/('.+')|(\.[\w\-]+)/, 1]
          highlight_inner_quote(jq_inside)
        else
          highlight_classes(jq_inside)
        end

        highlight_pseudo(jq_inside)
        highlight_num(jq_inside)
        '$("' + jq_inside + '")'
      end
    else
      highlight_nonjq_quote(string_input)
    end

    highlight_attr(string_input)
    highlight_html(string_input)
    highlight_pseudo(string_input)
    string_input
  end

  def highlight_inner_quote(string_input)
    string_input.gsub!(/('.*?')/, '<span class="quote">\1</span>')
  end

  def highlight_nonjq_quote(string_input)
    string_input.gsub!(/((["']).+?\2)/, '<span class="quote">\1</span>')
  end

  # .class or #id
  def highlight_classes(string_input)
    string_input.gsub!(/([\.|#][\w-]+)/, '<span class="cls">\1</span>')
  end

  def highlight_pseudo(string_input)
    string_input.gsub!(
      /(:[\w-]+(?:\(\))?|\bthis\b)/,
      '<span class="pseudo">\1</span>'
    )
  end

  def highlight_num(string_input)
    string_input.gsub!(/(?:\()(\d+)(?:\))/, '(<span class="num">\1</span>)')
  end

  def highlight_html(string_input)
    tags = %w[li ul p tr h1 h2 h3 h4 h5 h6 table input div]
    re = Regexp.new('\b(' + tags.join('|') + ')\b')
    string_input.gsub!(re, '<span class="html">\1</span>')
  end

  def highlight_attr(string_input)
    re = /(?:\[)(\w+)\b/
    string_input.gsub!(re, '[<span class="attr">\1</span>')
  end
end
