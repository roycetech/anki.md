require './lib/file_reader'
require './lib/utils/html_utils'

class CommandHighlighter < BaseHighlighter
  include HtmlUtils

  @@html_tags = nil

  def initialize
    @@html_tags ||= FileReader.read_as_list('html_element_names.txt')
    super
  end

  def comment_regex
    /^\$.*$/
  end

  def regexter_blocks(parser)
    pattern = %r{&lt;/?(?:#{@@html_tags.join('|')}).*&gt;}
    parser.regexter(
      'html',
      pattern,
      lambda(bt, br) do
        parser_inner = SourceParser.new
        parser.regexter(
          'expression',
          /\{\{.*?\}\}/,
          lambda do |blocktoken, _|
            blocktoken # no markup
          end
        )

        parser_inner.regexter(
          'quote',
          /(?<=)((["']).*?\2)/,
          ->(token, _) { HtmlUtil.span('quote', token) }
        )

        # optionally grab expression

        parser_inner.regexter(
          'html_tags',
          %r{&lt;\/?(\w+)(?:&gt;)?|&gt;$},
          lambda do |token, _|
            element_name = token[%r{&lt;\/?(\w+)(?:&gt;)?}, 1]

            if (@@html_tags.include? element_name) || element_name.nil?
              HtmlUtil.span('html', token)
            else
              token
            end
          end
        )

        parser_inner.regexter(
          'attr',
          /[\w\-]+/,
          ->(token, _) { HtmlUtil.span('attr', token) }
        )

        parser_inner.parse(blocktoken)
      end
    )
  end

  def regexter_singles(parser)
    ngattr_lambda = ->(token, _) {  wrap(:attr, token) }
    parser.regexter('ng_attr', /ng-\w+/, ngattr_lambda)
  end
end
