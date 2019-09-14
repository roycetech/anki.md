class Inline
  # RE_PATTERN = /(`)((?:\\\1|[^\1])*?)(\1)/

  # Supports escaped: `\``, same line only
  RE_PATTERN = /`(?:\\`|[^`\n])+`/.freeze
  RE_HTML_PATTERN = %r{
    <code\sclass="inline"> # match the html tag <code class="inline">
      .*?                 # match everything inside non-greedily.
    <\/code>              # match the ending </code>
  }x.freeze

  def initialize(highlighter)
    @highlighter = highlighter
  end

  def execute!(string_line)
    string_line.gsub!(RE_PATTERN) do |token|
      inline_code = token[RE_PATTERN, 2].gsub('\`', '`')
      %(<code class="inline">#{@highlighter.highlight_all(inline_code)}</code>)
    end
  end
end
