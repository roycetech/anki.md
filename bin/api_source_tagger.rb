require './lib/source_reader'
require './lib/latest_file_finder'
require './lib/tag_helper'

RE_TOKENS = /([a-z\?!]+)|\$\/|[+-]?\d/
EXCLUDE_FRONT = %w(or)
EXCLUDE_BACK = %w(Ruby e.g)
BODY_TAGS = %w(true catch false nil yield to_int to_s eval to_i padstr regexp each_char obj at_exit callcc)

# RE_WORDS = Regexp.quote(BODY_TAGS.join('|') + '|')
RE_WORDS = BODY_TAGS.join('|')

R = [ '%x{...}',                # Command
      'begin\.\.\.end',         # begin ...end
      '-[a-z](?:\/-[a-z])+',    # -a/-b
      '[\w\.]+ ==? [\w\.]+\.?',
      '[$A-Za-z_]+(?:\.[A-Za-z_=~]+(?:\([\d\D]*?\)+)?[!\?]?)+',   # Method call
      '\(?[$_\w]+(\.\w+\)?!?)+',
      '__\w+__',                # __FILE__
      '\w(?:[+*/-]\w)+\b;?',    # x+y.  Arithmetic
      '(?<= )-?\w+\d',          # File0.  Numbered words
      '\w*#[\[\]\w=<>_]+[\?!]?',    # this#hello. method
      '\b[A-Z][a-z]*([A-Z][a-z]*)+\b',                # DoubleWords
      '\+?\w+(?:\(\d*\))\+?',             # function(asdf), optionally wrapped by +
      '\\\\n{3}',                  # \nnn
      '0x\d*',                  # hex
       '0b[01]*',               # binary
      '\$(?:[\/_!\*:\\\\,\?])',     # special global $_. $! etc.
      '“.+?”',                  # quoted
      '‘.+?’',                  # quoted
      "'.+'",                   # quoted
      '\w+::\w+',               # This::now scope resolution
      'n(?:-bit)',               # n or n-bit.
      '[+-]?\d(?:\.\d+)?',
      '\b(?:(?:src|dst)_)encoding',
      'other_str(?:ing)?',
      '\b(?:' + RE_WORDS + ')\b',
      '(?:(?:from|to|match|new)_)?str\b',
      # '\b[+-]?\d+\b',              # digits
      '(?<!^|\. |\.  |— |—)(?:[A-Z][a-z]+)(?! —)(?= |,|;)',  # proper nouns
      '[a-z]+\?',
      '\w+:+\w+:?',   # custom.  line:file pr line:file:
      '\[\]',                   # []
      '=~',   # =~
      '\\\\r\\\\n',   #
      '\\\\[rn]\b'
    ]

      # 


puts R.join('|')
RE_TAG = Regexp.new(R.join('|'))
RE_TAG2 = %r{\(?[\w\$]+(\.\w+(?:\(\w*\))?)+||}


$write = true

class TagApiSource


  def execute(filename) 
    File.open(filename, 'r') do |file_source|
    File.open(filename + '.txt', 'w') do |file_output|

      card_count = 0
      SourceReader.new(file_source).each_card do |tags, front, back|
        card_count += 1

        tag_front(file_output, front)
        file_output << "\n" if $write
        
        # bs for skip back, fs for front skip
        if tags.include?'bs'
          if $write
            back.each do |element|
              file_output << "#{element}" 
            end
            file_output << "\n" 
          end
        else 
          tag_back(file_output, back)
        end
        if $write
          file_output << "\n\n" 
        end

      end

      puts "#{filename}: #{card_count}"

    end
    end

  end


  def tag_front(file_output, string_array)
    @words = []
    string_array.each do |line|

      line.scan(/[A-Za-z_]+/) do |token|
        if not @words.include?(token) and not EXCLUDE_FRONT.include?(token)
          @words.push token
        end
      end

      if !!line[/(.+) +(?=[→=])/]

        #  left of  =→>
        line.gsub!(/(.+) +(?=[→=])/) do |token|
          "`#{token.strip}` "
        end
        
        #  right of =→>
        if !!line[/ → (.+)/]
          re = / → (.+)/
        else
          re = / = (.+)/
        end

        line.gsub!(re) do |token1|
            token1.gsub(/[\w\$]+|\d+ \.{2,3} \d+/) do |token2|
              if not EXCLUDE_FRONT.include? token2
                "`#{token2}`"
              else
                token2
              end
            end
        end
      else 
        line.replace("`#{line}`")
      end
      file_output << line if $write
      file_output << "\n" if $write
      # puts line
    end
  end


  def tag_back(file_output, string_array)

    string_array.each do |line|
      if line.strip.empty?
        file_output << line if $write
      else

        if !!line[/ See/]
          line = line[0, line.index(/ See/)]
        elsif !!line[/\(see/]
          line[/ \(see.*?\)/] = '';
        elsif !!line[/ Also see/]
          line = line[0, line.index(/ Also see/)]
        elsif !!line[/ For examples/]
          line = line[0, line.index(/ For examples/)]
        end

        back = line.gsub(RE_TAG) do |token|
          if token == line[/[A-Z][a-z]+/]
            token
          else
            if EXCLUDE_BACK.include? token
              token
            else
              "`#{token}`"
            end
          end
        end

        if !@words.nil? && !@words.empty?

          re = '(?<=^|\s)(?:' + @words.join('|') + ')(?=[\s\.])'
          back.gsub!(Regexp.new(re)) do |token|
            "`#{token}`"
          end

          @words = []
        end

        if $write
          file_output << back
          file_output << "\n"
        end
      end
    end
  end
end

latest_api = LatestFileFinder.new(
  '/Users/royce/Dropbox/Documents/Reviewer/', '*.api'
).find
TagApiSource.new.execute(latest_api)
