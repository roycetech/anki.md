require './lib/highlighter/highlighter_csharp'
require './lib/html/html_tags'

class AspHighlighter < CSharpHighlighter
  def initialize
    super(HighlightersEnum::ASP)
  end

  def regexter_blocks(parser)
    parser.regexter('commandline', /^\$.*$/, lambda_cmd)
    parser.regexter('skip_br', /#{BR}/)
    html_tags = HtmlTags.instance.names
    parser.regexter('html', %r{<\/?(#{html_tags.join('|')}).*?>}, lambda_html)
  end

  def regexter_singles(parser)
    parser.regexter(
      'razor_model',
      /@(model) (\S+)/,
      lambda do |token, regexp|
        "@#{wrap(:html, token[regexp, 1])} #{escape_angles(token[regexp, 2])}"
      end
    )

    parser.regexter('razor_expr', /@\S+/, ->(token, _regexp) { token })
  end

  private # --------------------------------------------------------------------

  def lambda_cmd
    lambda do |outtoken, _outregexp|
      cmd_parser = SourceParser.new

      wrappexter(cmd_parser, 'optional', /\[.*\]/, :opt)
      wrappexter(cmd_parser, 'opt param', /(?!<\w)-[A-Za-z]\b/, :opt)

      cmd_parser.regexter('command', /\$ (\w+)\b/, lambda do |token, regexp|
        wrap(:cmd, token[regexp, 1])
      end)

      %(<span class="cmdline">$ #{cmd_parser.parse(outtoken)}</span>)
    end
  end

  def lambda_html
    lambda do |blocktoken, _blockregexp|
      parser_inner = SourceParser.new

      wrappexter(parser_inner, 'el_name', %r{(?<=<|<\/)(\w+)(?=\s|>)}, :html)
      wrappexter(parser_inner, 'quote', /(?<=)((["']).*?\2)/, :quote)
      wrappexter(parser_inner, 'attr', /[-\w]+/, :attr)
      parser_inner.regexter('<>=', %r{<\/?|>|=}, lambda do |token, _regex|
        wrap(:symbol, escape_angles(token))
      end)

      parser_inner.parse(blocktoken)
    end
  end
end
