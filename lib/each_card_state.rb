# State Holder for each iteration
class EachCardState
  attr_accessor :space_counter, :front, :back, :tags
  attr_reader :line_number

  def initialize(*args)
    reset
    @is_front    = true
    @card_began  = false # Marks the start of the first card.
    @line_number = 0

    return unless args.length > 2

    @tags, @front, @back = args
  end

  def reset
    reset_space
    @tags  = []
    @front = []
    @back  = []
  end

  def reset_space
    @space_counter = 0
  end

  def front?
    @is_front = if @space_counter >= 2
                  true
                elsif @space_counter == 1 && @is_front
                  @space_counter = 0
                  false
                else
                  @is_front
                end
  end

  def backless?
    @back.empty?
  end

  def frontless?
    @front.empty? || @front[0].strip.empty?
  end

  def card_began?
    @card_began
  end

  def new_card?
    space_counter >= 2
  end

  def next_line
    @line_number += 1
  end

  def inc_space_on_empty(line)
    @space_counter += 1 if line.empty?
  end

  def add_front(front)
    @front << front
  end

  def add_back(back)
    @back << back
  end

  def remove_back_last_blank
    @back.pop if @back.last&.empty?
  end

  def start_card(condition)
    @card_began ||= condition
  end

  def to_a
    [@tags, @front, @back]
  end
end
