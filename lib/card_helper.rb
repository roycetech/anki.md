require './lib/tag_helper'

# Helper class for each card iteration in SourceParser
class CardHelper
  def initialize(filename)
    @filename = filename
  end

  def handle(state, line, &block)
    if state.front?
      handle_front(state, line, &block)
    else
      handle_back(state, line)
    end
  end

  def blank_or_comment?(line)
    return true if line[/^#/] || line.strip.empty?

    false
  end

  private

  def handle_front(state, line)
    if state.space_counter >= 2 # write to file
      state.remove_back_last_blank
      yield state.to_a
      state.reset
    else
      register_front(state, line)
    end
  end

  def handle_back(state, line)
    return if line.empty? && state.backless?

    state.add_back(line)
    state.reset_space unless line.empty?
  end

  def register_front(state, line)
    validate_tag_declaration(line, line_number: state.line_number)
    if line[/@Tags: .*/]
      state.tags = TagHelper.parse(line)
    elsif state.tags.include? :Abbr
      state.add_front(line + ' abbreviation')
    else
      state.add_front(line)
    end
  end

  def validate_tag_declaration(line, line_number: 0)
    filemsg = "@File: #{@filename[/([-\w]+\.md)/, 1]}, " if @filename

    raise "ERROR: Misspelled #{filemsg}@Line #{line_number}:#{line}" if
      line[/@tags/i] && !line[/@Tags: .*/]
  end
end
