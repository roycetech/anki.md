# This extension adds the builder methods
class HTMLDSL
  def to_s
    @html_object.to_s
  end

  def build_block(name, attrs, &block)
    HTMLDSL.build(
      HtmlObject.new(
        name,
        options: attrs,
        level: @html_object.level + 1,
        single: false,
        first: @html_object.empty?
      ),
      &block
    )
  end

  def build_br(name, &block)
    HTMLDSL.build(
      HtmlObject.new(
        name,
        level: @html_object.level + 1,
        single: false,
        first: @html_object.empty?
      ), &block
    )
  end

  def build_proc(name, args)
    prc = proc { text args.last }
    class_opt = args[0] && args[0].is_a?(Symbol) && { class: args[0] }
    html_obj = HtmlObject.new(
      name,
      options: class_opt,
      level: @html_object.level + 1,
      single: true,
      first: @html_object.empty?
    )
    HTMLDSL.build(html_obj, &prc)
  end

  def build_missing(name, *args, &block)
    if block
      build_block(name, HTMLDSL.parse(*args), &block)
    elsif name == :br
      build_br(name, &block)
    else
      build_proc(name, args)
    end
  end

  def self.build(*args, &block)
    new(*args, &block).to_s
  end
end
