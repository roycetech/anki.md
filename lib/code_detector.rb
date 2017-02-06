require './lib/html/inline'
require './lib/html/code'

#
module CodeDetector
  def code?(card_lines)
    inline?(card_lines) || well?(card_lines)
  end

  # Expected the code to be translated already from backticks to <code>
  def inline?(array_or_codeblock)
    source = to_block_code(array_or_codeblock)
    if source =~ Inline::RE_HTML_PATTERN || source =~ Inline::RE_PATTERN
      true
    else
      false
    end
  end

  # param can be code block or string array
  def well?(array_or_codeblock)
    to_block_code(array_or_codeblock) =~ Code::RE_WELL ? true : false
  end

  def command?(code_block)
    code_block =~ Code::RE_CMD_WELL ? true : false
  end

  private

  def to_block_code(array_or_codeblock)
    if array_or_codeblock.is_a?(Array)
      array_or_codeblock.join("\n")
    else
      array_or_codeblock
    end
  end
end
