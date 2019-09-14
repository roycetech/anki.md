module RegexpUtils
  RE_QUOTE_SINGLE = /'(?:(?:\\')|[^'])*?'/.freeze
  RE_QUOTE_DOUBLE = /"(?:(?:\\")|[^"])*?"/.freeze
  RE_QUOTE_BOTH = /(["'])(?:(?:\\\1)|[^\1])*?\1/.freeze
end
