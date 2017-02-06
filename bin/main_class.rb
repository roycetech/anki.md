#!/usr/bin/env ruby

require './bin/main_requires'

# LOGGER = MyLogger.instance.freeze

#
class MainClass
  # Configuration
  Home_Path = File.expand_path('~')
  TSV_Output_Folder = "#{Home_Path}/Desktop/Anki Generated Sources".freeze

  # exposed for testability
  attr_reader :source_absolute_path, :html_generator

  # Initialize source file name.
  def initialize(source_file: nil)
    @reviewer = Reviewer.new
    @source_absolute_path = source_file
    LOGGER.info "File Path: #{@source_absolute_path}"
  end

  def generate_output_filepath
    today = Time.now
    basename = File.basename(@source_absolute_path, '.*')
    "#{Home_Path}/Desktop/Anki Generated Sources/#{basename} "\
    "#{today.strftime('%Y%b%d_%H%M')}.tsv"
  end

  # It opens source file for reading.
  # It opens CSV file.
  # It has to invoke #init_html_generator()
  def execute
    # LOGGER.info 'Program Start. Unit Test: %s' % ($unit_test ? 'Y' : 'n')
    # return if $unit_test

    File.open(@source_absolute_path, 'r') do |file|
      tag_counter = TagCounter.new

      # for testability
      tag_count_map = tag_counter.count_tags(file) if tag_counter
      output_absolute_path = generate_output_filepath

      init_html_generator(file)
      process_csv(output_absolute_path, tag_count_map, file)
    end
  end

  def init_html_generator(file)
    meta_map = MetaReader.read(file)
    language = meta_map[:lang] || 'none'
    LOGGER.info("Language: #{language}")

    highlighter = BaseHighlighter
    highlighter = if language
                    highlighter.send("lang_#{language.downcase}")
                  else
                    BaseHighlighter.lang_none
                  end
    @html_generator = HtmlGenerator.new(highlighter)
  end

  def process_card(csv, front, back, tags, count_map: {})
    tag_helper = TagHelper.new(tags: tags)
    tag_helper.index_enum(back)

    @reviewer.count_sentence(tag_helper, front, back)
    @reviewer.detect_sellouts(front, back) unless tag_helper.front_only?

    tsv_compat_lst = build_list(tag_helper, front, back, count_map)

    CardPrinter.print(tsv_compat_lst)

    @reviewer.register_front_card(tags, front)
    csv << tsv_compat_lst
  end

  private

  def process_csv(output_absolute_path, tag_count_map, file)
    CSV.open(output_absolute_path, 'w', col_sep: "\t") do |csv|
      SourceReader.new(file).each_card do |tags, front, back|
        process_card(csv, front, back, tags, count_map: tag_count_map)
      end

      @reviewer.print_all

      deckname = File.basename(output_absolute_path)
      puts('', deckname, '')
    end
  end

  def build_list(tag_helper, front, back, count_map)
    tsv_compat_lst = []
    tsv_compat_lst << @html_generator.format_front(tag_helper, front)
    tsv_compat_lst << @html_generator.format_back(tag_helper, back)
    tsv_compat_lst << SystemTagCounter.new.count(tag_helper, map: count_map)
    tsv_compat_lst
  end
end # End of MainClass
