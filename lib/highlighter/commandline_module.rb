require './lib/source_parser'

#
module CommandlineModule
  def regexter(parser)
    parser.regexter(
      'cmd',
      /```\w*\n(^\$ .*\n)+```/,
      lambda(_t, _r) { CommandHighlighter.new.high }
    )
  end
end
