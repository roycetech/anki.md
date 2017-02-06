# Terminology:
#   style - refers to the select block (selector and styles inside)
class SelectorDSL
  attr_accessor :selector, :styles_hash, :style_names

  def initialize(selector, name, value, &block)
    @selector = selector
    @styles_hash = {} # :symbol => string
    if block
      instance_eval(&block)
    else
      @styles_hash[name] = value
    end
  end

  def respond_to_missing?
    super
  end

  def method_missing(method_name_symbol, *args)
    return super if method_name_symbol == :to_ary

    method_name = method_name_symbol.to_s.tr('_', '-')
    @styles_hash[method_name.to_sym] = args[0]
  end

  # bandaid
  def display(value)
    @styles_hash[:display] = value
  end

  def apply_theme(theme)
    if @styles_hash.length == 1
      apply_theme_single(theme)
    else
      apply_theme_block(theme)
    end
  end

  def apply_theme_single(theme)
    array = @styles_hash.to_a[0]
    prop_name = array.to_a[0]
    new_value = theme.get(@selector, prop_name) || array[1]
    "  #{@selector} { #{prop_name}: #{new_value}; }"
  end

  def apply_theme_block(theme)
    str = "  #{@selector} {\n"
    @styles_hash.each_pair do |key, value|
      new_value = theme.get(@selector, key) || value
      str += "    #{key}: #{new_value};\n"
    end
    str += '  }'
  end

  def to_s
    if @styles_hash.length == 1
      array = @styles_hash.to_a[0]
      "  #{@selector} { #{array.to_a[0]}: #{array[1]}; }"
    else
      str = "  #{@selector} {\n"
      @styles_hash.each_pair { |key, value| str += "    #{key}: #{value};\n" }
      str += '  }'
    end
  end
end # class

# DSL Entry
def select(selector, name = nil, value = nil, &block)
  SelectorDSL.new(selector, name, value, &block)
end

__END__
# Example
output = select 'div.main' do
  text_align 'left'
       font_size '16pt'
      end

      puts(output.to_s)

      select('div.main')
        .text_align('left')
        .font_size('16pt')
      .select_e
