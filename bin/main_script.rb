require './bin/main_class'

PATH = ENV['ANKI_FOLDER']

unless PATH
  LOGGER.fatal 'Environment "ANKI_FOLDER" needs to be set'
  exit
end

unless UNIT_TEST
  if ARGV.empty? || ARGV[0] == 'upload'
    # - Generate a single file
    main = MainClass.new(source_file: LatestFileFinder.new(PATH, '*.md').find)
    main.execute

    RunSelenium.execute if !ARGV.empty? && 'upload'.casecmp(ARGV[0])

  else
    # - Generate multiple file
    finder = LatestFileFinder.new(PATH)
    finder.find
    last_updated_folder = finder.latest_folder
    generate_multi(last_updated_folder, ARGV[0])
  end
end

# - Generate for all files in a folder
def generate_multi(folder, file_wild_card)
  Dir[File.join(File.join(folder), file_wild_card)].each do |filename|
    LOGGER.info filename
    main = MainClass.new(source_file: filename)
    main.execute
    RunSelenium.execute
  end
end
