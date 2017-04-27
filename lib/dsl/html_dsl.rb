require './lib/dsl/indenter'
require './lib/dsl/html_object'
require './lib/dsl/html_dsl_extension'

#
class HTMLDSL
  include Indenter

  LEAF_TAGS = %i[br hr].freeze
  LF = "\n".freeze # Used only to alias, not to dry.

  def initialize(html_object, &block)
    @html_object = html_object
    instance_eval(&block) if block
  end

  def text(value)
    @html_object.add_next_content(value)
  end

  # allows repeating of elements
  def times(count)
    count.times { |i| yield(i) }
  end

  def merge(html_text)
    indented = html_text.lines.collect do |line|
      "#{indent(1)}#{line.chomp}"
    end.join("\n")
    @html_object.add_content "#{indented}\n"
  end

  def respond_to_missing?(name, _include_all)
    return true if name.match?(/\w+/)
    false
  end

  def method_missing(name, *args, &block)
    super unless respond_to_missing?(name, true)
    @html_object.add_content(build_missing(name, *args, &block))
  end

  def self.build(*args, &block)
    builder = new(*args, &block)
    builder.to_s
  end

  def to_s
    @html_object.to_s
  end

  def self.parse(*args)
    param1, param2 = args
    attrs = {}

    if param1.is_a? Symbol
      attrs = param1 && { class: param1 }
      attrs[:text] = param2 if param2.is_a? String
    elsif param1.is_a? String
      attrs[:text] = param1
    end
    attrs
  end
end

# text is available only for single liner.
def html(element_name, param1 = nil, param2 = nil, &block)
  attrs = HTMLDSL.parse(param1, param2)
  single = true if param1.is_a?(String) || param2.is_a?(String)

  HTMLDSL.new(
    HtmlObject.new(element_name, options: attrs, level: 0, single: single),
    &block
  ).to_s.strip
end
