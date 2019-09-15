require './lib/file_reader'

# Include angular directives ng-*.
class WebHighlighter < JsHighlighter
  @html_tags = nil # if you are wondering, yes this is required.

  def initialize
    @html_tags = FileReader.read_as_list('html_element_names.txt')
    super
  end

  def comment_regex
    %r{\/\/ .*|\/\*.*\*\/|&lt;!--.*--&gt;}
  end

  def regexter_blocks(parser)
    pattern = Regexp.new("&lt;\\/?(?:#{@html_tags.join('|')}).*&gt;")
    parser.regexter('html', pattern, lambda do |token, _re_name|
      parser_inner = SourceParser.new

      parser.regexter(
        'expression',
        /\{\{.*?\}\}/,
        ->(blocktoken, _name) { blocktoken }
      )

      parser_inner.regexter(
        'quote',
        /(?<=)((["']).*?\2)/,
        ->(blocktoken, _name) { HtmlUtil.span('quote', blocktoken) }
      )

      parser_inner.regexter(
        'html_tags',
        %r{&lt;/?(\w+)(?:&gt;)?|&gt;$},
        html_tag_lambda
      )

      parser_inner.regexter(
        'attr',
        /[\w\-]+/,
        ->(blocktoken, _name) { HtmlUtil.span('attr', blocktoken) }
      )

      parser_inner.parse(token)
    end)
  end

  # TODO: Angular Specific.
  def regexter_singles(parser)
    ngattr_lambda = ->(token, _re_name) { HtmlUtil.span('attr', token) }
    parser.regexter('ng_attr', /ng-\w+/, ngattr_lambda)
  end

  private

  def html_tag_lambda
    lambda do |blocktoken, _name|
      element_name = blocktoken[%r{&lt;\/?(\w+)(?:&gt;)?}, 1]

      if (@@html_tags.include? element_name) || element_name.nil?
        HtmlUtil.span('html', blocktoken)
      else
        blocktoken
      end
    end
  end
end
