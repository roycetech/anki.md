# Manage state in the DSL Object
class HtmlObject
  include Indenter
  attr_accessor :level, :element_name, :classes, :contents

  LF = "\n".freeze # Used only to alias, not to DRY.
  LEAF_TAGS = [:br, :hr].freeze

  # single for single-line, options to hold single style classes.
  def initialize(element_name = 'html',
                 options: nil,
                 level: 0,
                 single: false,
                 first: false)

    @element_name = element_name
    @level        = level
    @contents     = []
    @single       = single
    @first        = first

    init(options)
  end

  def add_next_content(value)
    @contents << "#{indent(@level + 1)}#{value}"
  end

  def add_content(value)
    @contents << value
  end

  def empty?
    @contents.empty?
  end

  def to_s
    attrs = compute_attributes
    tag = "#{indent(@level)}<#{@element_name}"\
          "#{' ' unless attrs.empty?}#{attrs}>"

    return "#{tag}\n" if LEAF_TAGS.include?(@element_name.to_sym) && !@first
    return tag if LEAF_TAGS.include?(@element_name.to_sym)
    compute_output(tag)
  end

  private # --------------------------------------------------------------------

  def init(options)
    @classes = options || {}
    return unless options && @classes[:text]

    add_content(@classes[:text])
    @classes.delete(:text)
  end

  def compute_output(tag)
    if @contents.empty? || @single
      "#{tag}#{@contents.join(LF).strip}</#{@element_name}>\n"
    else
      "#{tag}\n"\
      "#{@contents.join.rstrip}\n"\
      "#{indent(@level)}</#{@element_name}>\n"
    end
  end

  def compute_attributes
    return '' if @classes.nil? || @classes.empty?

    @classes.map { |k, v| %(#{k}="#{v}") } .join(' ')
  end
end
