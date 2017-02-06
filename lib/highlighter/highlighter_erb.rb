require './lib/highlighter/base_highlighter'

#
class ErbHighlighter < BaseHighlighter
  def initialize(param = HighlightersEnum::RUBY)
    super
  end

  def comment_regex
    RegextrationStore::CommentBuilder.new.perl.build
  end

  def string_regex
    RE_QUOTE_BOTH
  end

  def regexter_blocks(parser)
    parser.regexter('commandline', /^\$.*$/, lambda_cmd)
  end

  def regexter_singles(parser)
  end

  private # --------------------------------------------------------------------

  def lambda_cmd
    lambda do |outtoken, _outregexp|
      cmd_parser = SourceParser.new

      cmd_parser.regexter('command', /\$ (\w+)\b/, lambda do |token, regexp|
        wrap(:cmd, token[regexp, 1])
      end)

      %(<span class="cmdline">$ #{cmd_parser.parse(outtoken)}</span>)
    end
  end
end
