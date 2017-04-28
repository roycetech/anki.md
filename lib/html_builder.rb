require './lib/style_builder'

# end tags have the format tag_e
# if end tag, new line is appended when value is true
# for text tag, the value is the actual text.
# no need for manual lf on styles.
class HtmlBuilder
  include HtmlUtils

  SPECIAL_TAGS = %w(text lf space br style style_e).freeze
  TAG_SPAN_E   = 'span_e'.freeze
  TAG_BR       = 'br'.freeze
  LF           = "\n".freeze

  # last_element includes text and br
  attr_reader :styled, :last_tag, :last_element

  def initialize(html_builder = nil)
    @tags = []
    @values = []
    @styled = false

    merge(html_builder) if html_builder
  end

  def to_s
    return_value = LF + self.class.to_s + '------------------------------' + LF
    return_value += format('  Styled [%s]',
                           (styled ? 'Y' : 'n') + LF + '  Tags:' + LF)

    @tags.each_index do |index|
      return_value += format("  %-8s => %s\n", @tags[index], @values[index])
    end
    return_value
  end

  # Accepts html another HtmlBuilder or StyleBuilder.
  # Style should come first! :)
  def merge(builder)
    if builder.is_a? StyleBuilder

      if @styled
        unless @values.empty?
          last = @values.pop
          last += builder.value
          @values.push(last)
        end
      else
        @tags.push('style')
        @values.push(builder.value)
        @styled = true
      end
      StyleBuilder.new(self)
    elsif builder.is_a? HtmlBuilder
      raise 'Second builder cannot have a style' if builder.styled

      @styled ||= builder.styled

      unless @tags.last == 'lf' || @tags.last == 'br'
        @tags.push('lf')
        @values.push nil
      end

      builder.each_with_value do |tag, value|
        @tags.push(tag)
        @values.push(value)
      end
      builder
    end
  end

  def build
    return_value = ''
    level = 0
    last_tag = nil
    last_lfed = false # last tag invoked new line

    each_with_value do |tag, value|
      value = value.to_s if value
      is_open_tag = !tag.include?('_')
      unless SPECIAL_TAGS.include?(tag)
        do_indent = level > 0 && last_lfed
        if is_open_tag
          return_value += ' ' * (2 * level) if do_indent
          level += 1
        else
          level -= 1
          return_value += ' ' * (2 * level) if do_indent
        end
      end

      if tag == 'text' && last_lfed && last_tag != 'pre'
        return_value += ' ' * (2 * level)
      end

      return_value += case tag
                      when 'space' then ESP
                      when 'lf' then LF
                      when 'br'
                        brlf = BR + LF
                        return_value.chomp! unless return_value.end_with?(brlf)
                        BR + LF
                      when 'text' then value
                      when 'style' then "<style>\n" + value
                      else
                        if is_open_tag
                          klass = %( class="#{value}") if value
                          "<#{tag}#{klass}>"
                        else
                          "</#{tag[/[a-z]+/]}>" # span_e => span
                        end
                      end

      last_tag = tag unless SPECIAL_TAGS.include?(tag)
      last_lfed = %w(lf br).include?(tag)
    end # each loop

    return_value
  end

  def respond_to_missing?
    super
  end

  # Will handle tag and tag_e only.
  def method_missing(meth, *args, &block)
    if args.length <= 1
      method_missing_one_most(meth.to_s, args)
    else
      super
    end
  end

  def method_missing_one_most(meth_name, *args)
    @tags.push(meth_name)
    is_end_tag = meth_name.include?('_e')
    if is_end_tag && args.empty?
      @values.push(true)
    else
      @values.push(args[0])
    end

    @last_tag = meth_name unless SPECIAL_TAGS.include? meth_name
    @last_element = meth_name unless %w(lf space).include? meth_name

    self
  end

  def size
    @values.size
  end

  def insert(tag, value = nil)
    @tags.insert(0, tag)
    @values.insert(0, value)
    self
  end

  protected

  def each_with_value
    @tags.each_index { |index| yield @tags[index], @values[index] }
  end
end
