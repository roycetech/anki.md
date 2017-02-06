# DSL for Theme
class ThemeDSL
  attr_reader :hash, :children

  def initialize(parent: nil, selector: nil, hash: nil, &block)
    @hash = hash || {}
    @parent = parent
    @selector = selector
    @children = {}
    instance_eval(&block) if block
  end

  def select(selector, property = {}, &block)
    if block
      @children[selector] = ThemeDSL.new(
        parent: self, selector: selector, &block
      )
    else
      @children[selector] = ThemeDSL.new(
        parent: self, selector: selector, hash: property, &block
      )
    end
  end

  # accept the property name as string or symbol
  def get(selector, property)
    return unless @children[selector]

    @children[selector].hash[property.to_s] ||
      @children[selector].hash[property.to_sym]
  end

  def respond_to_missing?
    super
  end

  def method_missing(method_symbol, *args, &block)
    return super if method_symbol == :to_ary

    method_name = method_symbol.to_s
    if block
      @children[method_name] = ThemeDSL.new(parent: self, &block)
    else
      @hash[method_name.tr('_', '-')] = args[0]
    end
  end
end # class

# DSL Entry
def theme(&block)
  ThemeDSL.new(&block)
end

__END__

output = theme do
  select 'code.well' do
    background_color('black')
  end
  select 'span.answer', color: 'red'
  select 'span.attr', color: 'silver'
end

puts(output)

# puts(output.get('code.well', 'background-color'))
# puts(output.get('span.attr', :color))
# puts(output.get('span.attr', 'color'))
