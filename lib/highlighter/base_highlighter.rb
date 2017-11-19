require './lib/wrappexter'
require './lib/markdown'
require './lib/regextration_store'
require './lib/highlighter/keyword_highlighter'
require './lib/highlighter/highlighters_enum'
require './lib/utils/regexp_utils'
require './lib/source_parser'

# requires reviewed Sept 23, 2016
# NOTE: Highlighter implementing classes "requires" at the bottom of this file.

# Base class will handle keyword, and comment, provided sub class supply
# keyword list and line comment markers.
class BaseHighlighter
  include Wrappexter
  include Markdown
  include RegexpUtils

  attr_reader :type

  def self.respond_to_missing?(name, _include_all)
    method_name = name.to_s
    method_name =~ /^lang_(\w+)/
  end

  # Factory methods.
  def self.method_missing(name, *args)
    regex = /^lang_(\w+)/
    method_name = name.to_s
    return super unless method_name.match?(regex)

    Object.const_get("#{method_name[regex, 1].capitalize}Highlighter").new
  end

  # Define here if it don't follow standard naming.
  def self.jquery
    JQueryHighlighter.new
  end

  def self.csharp
    CSharpHighlighter.new
  end

  RE_HTTP = %r{
    ^             # match beginning of string
    http          # match text 'http'
    s?            # optionally followed by 's'
    :\/\/         # follow by text '://'
    \w+           # followed by a word
    (?:\.\w+)*    # can be followed with more dot and word
    (?::\d{1,5})? # optionally followed by a port number i.e. ":12345"
    (?:\/\w+)*    # followed by 0 or more /word
    \/?           # optionally ending with a '/'
    $             # match ending of a string
  }x

  def initialize(type)
    @parser = SourceParser.new
    @type = type # initialized by subclass

    init_pre_block_regexes(@parser)
    regexter_blocks(@parser)

    wrappexter(@parser, 'strings', string_regex, :quote)
    wrappexter(@parser, '<user_identifier>', /#{ELT}[\w ]*?#{EGT}/, :user)

    init_keywords

    regexter_singles(@parser)
    @parser.regexter('escaped', /\\(.)/, ->(token, regexp) { token[regexp, 1] })
  end

  private :initialize

  def init_pre_block_regexes(parser)
    wrappexter(parser, 'http_url', RE_HTTP, :url)

    parser.regexter('comment', comment_regex, lambda do |token, _regexp|
      wrap(:comment, token.sub(BR, ''))
    end)
  end

  def init_keywords
    return unless keywords_file

    keyworder = KeywordHighlighter.new(keywords_file)
    keyworder.register_to(@parser)
  end

  # Override to register specific blocks
  def regexter_blocks(parser); end

  def regexter_singles(parser); end

  def keywords_file; end

  # Subclass should return regex string
  def comment_regex
    abstract
  end

  # Subclass should return regex string for string literals
  def string_regex
    abstract
  end

  def mark_known_codes(input_string)
    # @parser.regexter('bold', BOLD[:regexp], BOLD[:lambda])
    # @parser.regexter('italic', ITALIC[:regexp], ITALIC[:lambda])

    input_string.replace(@parser.format(input_string))
    escape_spaces!(input_string)
  end
end

require './lib/highlighter/highlighter_none'
require './lib/highlighter/highlighter_ruby'
require './lib/highlighter/highlighter_js'
require './lib/highlighter/highlighter_cpp'
require './lib/highlighter/highlighter_java'
require './lib/highlighter/highlighter_swift'
require './lib/highlighter/highlighter_plsql'
require './lib/highlighter/highlighter_php'
require './lib/highlighter/highlighter_web'
require './lib/highlighter/highlighter_objc'
require './lib/highlighter/highlighter_jquery'
require './lib/highlighter/highlighter_python'
require './lib/highlighter/highlighter_git'
require './lib/highlighter/highlighter_spring'
require './lib/highlighter/highlighter_sql'
require './lib/highlighter/highlighter_csharp'
require './lib/highlighter/highlighter_asp'
require './lib/highlighter/highlighter_erb'
