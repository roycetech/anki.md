module RegexpUtils
  RE_QUOTE_SINGLE = /'(?:(?:\\')|[^'])*?'/
  RE_QUOTE_DOUBLE = /"(?:(?:\\")|[^"])*?"/
  RE_QUOTE_BOTH = /(["'])(?:(?:\\\1)|[^\1])*?\1/
end
