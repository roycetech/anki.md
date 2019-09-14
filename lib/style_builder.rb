class StyleBuilder
  # Colorizer is an object that determines the actual color to use
  def initialize(html_builder = nil, colorizer = nil)
    @html_builder = html_builder
    @colorizer = colorizer

    # these two used per selectors
    @prop_hash = {}

    # used to maintain order of property names of hash.
    @prop_names = []
    @current_selector = nil

    @values = [] # holds all the styles
  end

  def merge(style_builder)
    style_builder.each { |value| @values.push(value) }
    self
  end

  def select(selector)
    @current_selector = selector
    @values.push(selector + ' {')
    self
  end

  def select_e
    @current_selector = nil
    @prop_names.sort!
    @prop_names.each do |name|
      value = @prop_hash[name]
      @values.push format('  %s: %s;', name, value)
    end

    @values.push '}'
    @prop_hash.clear
    @prop_names.clear

    self
  end

  def style_e
    err_msg = 'End style must originate from html builder only. '
    raise err_msg if @html_builder.nil?

    @html_builder.merge(self)
    @html_builder
  end

  def value
    @values.inject('') { |a, e| a + '  ' + e + "\n" }
  end

  def build
    @values.inject('') { |a, e| a + e + "\n" }
  end

  def display(param)
    method_name = 'display'
    @prop_hash[method_name] = param
    @prop_names.push(method_name)
    self
  end

  def respond_to_missing?
    super
  end

  def method_missing(meth, *args, &block)
    if args.length == 1
      name = meth.to_s.tr('_', '-')
      @prop_names.push(name)
      @prop_hash[name] = change(name, args[0])
      self
    else
      super
    end
  end

  def change(name, color)
    if @colorizer
      @colorizer.convert(@current_selector, name, color)
    else
      color
    end
  end

  def each
    @values.each { |value| yield value }
  end

  def to_s
    @values.inject("\n" +
      self.class.to_s +
      '------------------------------------' +
      format("\n  HtmlBuilder[%s]", (@html_builder ? 'Y' : 'n')) +
      "\n") do |result, value|
      result + "#{value}\n"
    end
  end
end
