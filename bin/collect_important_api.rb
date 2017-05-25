require './lib/source_reader'
require './lib/tag_helper'
require './lib/latest_file_finder'
require './lib/mylogger'
require './lib/meta_reader'
require './lib/html_helper'
require './lib/highlighter/highlighters_enum'
require './lib/source_parser'
require './lib/tag_counter'
require './lib/class_extensions'
require './bin/upload' unless $unit_test

require 'CSV'

#
class CollectImportantApi
  LOGGER = MyLogger.instance.freeze

  def run
    file_mask = '*.md'
    find_path(file_mask)
    read_list
    LOGGER.info("Deckname: #{@deckname}")
    generate_output_filename
    @@highlighter = BaseHighlighter

    total = 0
    main_list = []
    tag_counter = TagCounter.new

    Dir[File.join(@path, file_mask)].each do |filename|
      next if filename.include?('README.md')

      File.open(filename, 'r') do |file|
        meta_map = MetaReader.read(file)
        common_tag = meta_map['commontag']
        @tag_count_map = tag_counter.count_tags(file, common_tag)

        if @@highlighter.class == Class
          language = meta_map['lang']
          LOGGER.debug("Language: #{language}")
          @@highlighter = if language
                            @@highlighter.send("lang_#{language.downcase}")
                          else
                            BaseHighlighter.lang_none
                          end
        end

        SourceReader.new(file).each_card do |tags, front, back|
          tags.push(common_tag) if common_tag
          unticked = front[0].delete('`') unless front[0].nil?
          next unless front_included(unticked) || tags.any? && !(@list & tags).empty?
          write_card(main_list, front, back, tags)

          output = ''
          output += "@Tags: #{tags.join(', ')}\n" unless tags.empty?
          output += (front[0].chomp + "\n\n")
          output += back[0]
          output += "\n\n\n"

          total += 1
        end
      end
    end

    CSV.open(@@outputFilename, 'w', col_sep: "\t") do |csv|
      main_list.each { |element| csv << element }
    end

    LOGGER.info("Total: #{total}")

    RunSelenium.execute
  end

  def generate_output_filename
    today = Time.now

    @@outputFilename = '%s/Desktop/Anki Generated Sources/%s %s%s%s_%s%s.tsv' %
                       [
                         File.expand_path('~'),
                         @deckname,
                         today.year % 1000,
                         '%02d' % today.month,
                         '%02d' % today.day,
                         '%02d' % today.hour,
                         '%02d' % today.min
                       ]
  end

  def front_included(front_card)
    @list.each { |element| return true if front_card[/\b#{element}\b/] }
    false
  end

  # Find the path where the last file was modified.
  def find_path(file_mask)
    finder = LatestFileFinder.new(ENV['ANKI_FOLDER'], file_mask)
    finder.find
    @path = finder.latest_folder
    LOGGER.debug("Path: #{@path}")
  end

  def read_list
    @list = []
    File.open("#{@path}/Zimportant.lst", 'r') do |file|
      meta_map = MetaReader.read(file)
      @deckname = meta_map['filename']

      file.each_line do |line|
        @list.push(line.strip) if line[0] != '#' && !line.chomp.empty?
      end

      # while line = file.gets
      #   @list.push(line.strip) if line[0] != '#' && !line.chomp.empty?
      # end
    end
  end

  def write_card(main_list, front, back, tags)
    tag_helper = TagHelper.new(tags)

    back.pop if back[-1] == ''
    tag_helper.find_multi(back)

    html_helper = HtmlHelper.new(@@highlighter, tag_helper, front, back)
    lst = [html_helper.front_html, html_helper.back_html]

    lst = card_tagger(tag_helper, lst)
    main_list.push(lst)
  end

  private

  def card_tagger(tag_helper, list)
    if tag_helper.untagged?
      list.push 'untagged'
    else
      tags_numbered = number_tag(tag_helper.tags)
      list.push tags_numbered.join(',')
    end
    list
  end

  def number_tag(tags)
    tags.map do |tag|
      count = @tag_count_map[tag]
      if count == 1
        tag
      else
        "#{tag}(#{count})"
      end
    end
  end
end # CollectImportantApi

CollectImportantApi.new.run
