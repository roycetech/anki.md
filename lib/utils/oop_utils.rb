module OopUtils
  def abstract
    calling_method = caller[0][/`.*'/][1..-2]
    raise NotImplementedError, "You must implement the #{calling_method} method"
  end
end
