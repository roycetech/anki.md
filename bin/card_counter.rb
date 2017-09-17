require './lib/source_reader'
require './lib/tag_helper'
require './lib/latest_file_finder'
require './lib/mylogger'

LOGGER = MyLogger.instance

SOURCE_FOLDER = ENV['ANKI_FOLDER'].freeze

# Use folder of last modified file
FILE_MASK = '*.md'.freeze
finder = LatestFileFinder.new(SOURCE_FOLDER, FILE_MASK)
finder.find

PATH = finder.last_modified_folder
# LOGGER.debug("Path: #{PATH}")

total_cards = 0
total_files = 0
total_api = 0

Dir[File.join(PATH, FILE_MASK)].each do |filename|
  next unless filename.match?(/\.(?:md|api)$/m)

  total_files += 1
  File.open(filename, 'r') do |file|
    card_count = 0
    SourceReader.new(file).each_card do |_, _, _|
      card_count += 1
    end
    total_api += card_count if filename.include?'-API-'
    puts "#{filename}: #{card_count}"
    total_cards += card_count
  end
end

puts "Total files: #{total_files}"
puts "Total cards: #{total_cards}"
puts "Total API cards: #{total_api}"
puts "Total non-API cards: #{total_cards - total_api}"
