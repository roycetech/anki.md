require './lib/dsl/html_dsl'
require './lib/dsl/style_dsl'
require './lib/utils/html_utils'
require './lib/html/code'
# Review requires below.

require './lib/html_builder'
require './lib/highlighter/base_highlighter'

require './lib/html/inline'

require './lib/html/style_generator'
require './lib/html/colorizer_template'

require './lib/code_detector'
require './lib/cmd_detector'

# f suffix refers to front card, b for back card.
class HtmlGenerator
  include Markdown
  include HtmlUtils
  attr_reader :front_html, :back_html, :highlighter

  # RE_QUIZ_SELECTED = /(?<=\([*x]\)\s).*/i.freeze
  # RE_QUIZ_CHECKED =  /(?<=\[[*x]\]\s).*/i.freeze
  RE_QUIZ_SELECTED = /(?<=\([*x]\)\s).*/.freeze
  RE_QUIZ_CHECKED =  /(?<=\[[*x]\]\s).*/.freeze
  RE_CHECK_OPTION = /(?<=\[\]\s).*|(?<=\[[*x]\]\s).*/.freeze
  RE_SELECT_OPTION = /(?<=\(\)\s).*|(?<=\([*x]\)\s).*/.freeze

  def initialize(highlighter)
    assert highlighter.is_a?(BaseHighlighter)
    @highlighter = highlighter
  end

  def format_front(tag_helper, front_array, back_array)
    card_block = front_array.join("\n")

    untagged = tag_helper.untagged? || tag_helper.back_only?
    tags_html = build_tags(tag_helper) # VERIFY IF NESTED works

    output = if tag_helper.quiz?
               build_quizf(front_array, back_array)
             else
               Code.new(@highlighter).mark_codes(card_block)
               html :div, :mainf do
                 merge(tags_html) unless untagged
                 text card_block
               end
             end

    build_style(tag_helper, card_block, mark(output), :style_front)
  end

  def format_back(tag_helper, back_array)
    card_block = back_array.join("\n")

    output = if tag_helper.quiz_choice?
               build_quizb(back_array)
             elsif tag_helper.enum?
               build_enum(tag_helper, card_block)
             elsif tag_helper.figure?
               build_figure(back_array)
             else
               build_back_else(tag_helper, card_block)
             end

    build_style(tag_helper, card_block, mark(output), :style_back)
  end

  def build_style(tag_helper, card_block, output, face)
    style = StyleGenerator.new(
      tag_helper,
      @highlighter.type
    ).send(face, card_block)

    "#{style}\n#{output}"
  end

  def build_main
    Code.new(@highlighter).mark_codes(card_block)
    untagged = tag_helper.untagged? || tag_helper.front_only?
    html :div, :main do
      merge(tag_htmls) unless untagged
      text card_block
    end
  end

  def build_tags(tag_helper)
    html :div, :tags do
      tag_helper.visible_tags.each do |tag|
        span :tag, tag
      end
    end
  end

  private # --------------------------------------------------------------------

  def build_figure(back_array)
    html :div, :main do
      pre :fig do
        text back_array.inject('') do |result, element|
          result + "\n" unless result.empty?
          result + element
        end
      end
    end
  end

  def build_enum(tag_helper, card_block)
    Code.new(@highlighter).mark_codes(card_block)

    return build_ol(card_block) if tag_helper.ol?

    build_ul(card_block) if tag_helper.ul?
  end

  # attach the choices to the front card, removing the answers
  def build_quizf(front_array, back_array)
    front_array << ''

    option_types = []
    back_array.each do |element|
      option_types << element[0]
      front_array << element[/(?<=\[[*x]\]\s).*|(?<=\[\]\s).*|(?<=\([*x]\)\s).*|(?<=\(\)\s).*/]
    end

    coder = Code.new(@highlighter)
    coder.mark_codes(front_array.first)
    front_array[2..].map! do |element|
      coder.mark_codes(element)
      element
    end

    html :div, :mainf do
      text front_array.first
      times(2) { br }
      letter = 'a'
      front_array[2..].each_with_index do |line, index|
        input_options = {
          type: option_types[index-2] == '(' ? :radio : :checkbox,
          name: :choices,
          id: "choicef#{index + 1}"
        }
        input input_options, ''
        label_options = { for: "choicef#{index + 1}" }
        label label_options, "#{letter}) #{line}"
        letter.next!
        br
      end
    end
  end

  # convert markdown to radio buttons, with the correct answers checked.
  def build_quizb(back_array)
    # 1. Displays the letters only of the correct answer
    # answers = []
    # letter = 'A'

    # back_array.each do |element|
    #   answers << letter if element[RE_QUIZ_SELECTED]
    #   letter = letter.next
    # end

    # answer_text = if answers.size == 2
    #                 "#{answers.first} and #{answers[1]}"
    #               elsif answers.size > 2
    #                 "#{answers[0..-2].join(', ')}, and #{answers.last}"
    #               else
    #                 answers.first
    #               end

    # 2. Displays the correct answer choices only.

    html :div, :mainb do
      # text answer_text

      letter = 'a'
      back_array.each_with_index do |line, index|
        selected = line[RE_QUIZ_SELECTED]
        checked = line[RE_QUIZ_CHECKED]

        if selected || checked
          input_options = {
            type: selected ? :radio : :checkbox,
            checked: true,
            id: "choice#{index + 1}"
          }

          input input_options, ''

          label_options = { for: "choice#{index + 1}" }
          label label_options, "#{letter}) #{selected ? line[RE_SELECT_OPTION] : line[RE_CHECK_OPTION]}"

          # if selected
          #   label label_options, "#{letter}) #{line[RE_SELECT_OPTION]}"
          # else
          #   label label_options, "#{letter}) #{line[RE_CHECK_OPTION]}"
          # end
          br
        end
        letter.next!
      end
    end
  end

  def build_ol(card_block)
    html :div, :mainb do
      ol do
        card_block.each_line do |line|
          li line
        end
      end
    end
  end

  def build_ul(card_block)
    html :div, :mainb do
      ul do
        card_block.each_line do |line|
          li line
        end
      end
    end
  end

  def build_back_else(tag_helper, card_block)
    Code.new(@highlighter).mark_codes(card_block)
    untagged = tag_helper.untagged? || tag_helper.front_only?
    tags_html = build_tags(tag_helper) # VERIFY IF NESTED works
    html :div, :mainb do
      merge(tags_html) unless untagged
      merge(card_block)
    end
  end
end
