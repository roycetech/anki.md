require './lib/each_card_state'
require './lib/card_helper'

# This class is todoc
class SourceReader
  def initialize(file)
    @file = file
    @card_helper = CardHelper.new File.basename(file.path)
  end

  def each_card(&block)
    state = EachCardState.new
    while (line = @file.gets&.rstrip)
      state.next_line
      state.start_card(!@card_helper.blank_or_comment?(line))
      next unless state.card_began?

      state.inc_space_on_empty(line)
      @card_helper.handle(state, line, &block)
    end
    yield state.to_a unless state.frontless?
  end
end
