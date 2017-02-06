require './lib/assert'
require './lib/markdown'

# It detects code wells,
# appends some needed <br>'s ?
# Escapes some spaces with &nbsp; ?
class Code
  include Assert, Markdown

  WELL_START = '<code class="well">'.freeze
  RE_WELL = %r{^(```|#{WELL_START})([a-zA-Z]*\n)([\d\D]*?)(\1|<\/code>)}
  RE_CMD_WELL = %r{(?:```|#{WELL_START})\w*\n(\$ .*\n)+(?:```|<\/code>)}

  def initialize(highlighter)
    @highlighter = highlighter
  end

  def mark_codes(string)
    parser = SourceParser.new

    regexter_wells(parser)
    regexter_inlines(parser)
    string.replace(parser.parse(string))
  end

  def regexter_wells(parser)
    parser.regexter('wells', RE_WELL, lambda do |token, regexp|
      code_block = token[regexp, 3].chomp

      @highlighter.mark_known_codes(code_block)
      code_block.gsub!("\n", "<br>\n")
      %(<code class="well">\n#{code_block}\n</code>)
    end)
  end

  def regexter_inlines(parser)
    parser.regexter(
      'inlines',
      /`((?:\\`|[^`\n])+)`/,
      lambda do |token, regexp|
        code = token[regexp, 1]
        @highlighter.mark_known_codes(code)
        %(<code class="inline">#{code}</code>)
      end
    )
  end
end
