require './lib/tag_helper'
require './lib/reviewer_printer'

# This class is used to quality check cards.  It will log
# if there are any known violations.
#
# Counts sentence so you can review complexity
# Checks if front card appears at the back of the card.
class Reviewer
  attr_reader :all_sellout, :all_multi, :all_front

  def initialize
    @all_multi   = []
    @all_sellout = []
    @all_front   = [] # will be used to review if duplicates are valid.
    @all_multi   = [] # will be used to review complex cards
    @all_sellout = [] # will be used to review of question that appear in answer
    @all_front_tag_map = {} # will be used to review if duplicates are valid.
  end

  # Detect single word front cards that appears in back card.
  def detect_sellouts(front_array, back_array)
    return unless front_array.length == 1

    front_card = front_array[0].downcase
    back_joined = back_array.join("\n").downcase
    return unless Regexp.new(Regexp.escape(front_card))
                        .match(back_joined)

    @all_sellout.push(front_array[0])
  end

  # detects back cards with multiple sentences.
  def count_sentence(tag_helper, front_array, back_array)
    sentence_cnt = if tag_helper.include? :Syntax
                     1
                   else
                     count_non_syntax_sentence(back_array)
                   end

    create_tag(sentence_cnt, tag_helper, front_array)
    sentence_cnt.zero? ? 1 : sentence_cnt
  end

  def count_non_syntax_sentence(back_array)
    sentence_cnt = back_array.inject(0) do |total, element|
      translated = element.downcase
                          .gsub(/e\.g\.?|i\.e\.?/, 'eg')
                          .gsub(/(\d+)(?:(\.)(\d*))/, '\1_\3')
                          .gsub(/(?:[a-zA-Z_]*)(?:\.[a-zA-Z_]+)+/, 'javapkg')
                          .gsub(/\.{2,}/, '')
      total + translated.count('.')
    end
    return sentence_cnt + 1 unless back_array[0][-1] == '.'

    sentence_cnt
  end

  def create_tag(sentence_cnt, tag_helper, front_array)
    return unless sentence_cnt > 1 && !tag_helper.enum?

    multi_tag = format('Multi:%<count>d', count: sentence_cnt)

    return if tag_helper.include? multi_tag

    tag_helper.add_multi(multi_tag)
    count_str = format('(%<count>d)', count: sentence_cnt)
    @all_multi.push(front_array.join("\n") + count_str) if sentence_cnt > 1
  end

  # Used to analyze later for duplicates
  def register_front_card(tags, front_card)
    front_key = tags.join(',') + front_card.join("\n")
    @all_front.push(front_key)
    @all_front_tag_map[front_key] = front_card.join("\n")
  end

  def print_all
    ReviewerPrinter.new(self).print_all
  end
end
