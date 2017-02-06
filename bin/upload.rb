# :nocov:
require './lib/latest_file_finder'
require './lib/config'
require 'selenium-webdriver'
require './lib/mylogger'

#
class RunSelenium
  BASE_URL = 'https://api.ankiapp.com/'.freeze
  LOGGER = MyLogger.instance

  def self.execute
    LOGGER.info 'RunSelenium started...'

    driver = Selenium::WebDriver.for :firefox
    @accept_next_alert = true
    driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []

    driver.navigate.to "#{BASE_URL}nexus/"

    driver.find_element(:css, 'input.flex-item').clear
    driver.find_element(:css, 'input.flex-item').send_keys(Config::USERNAME)
    driver.find_element(:css, 'input[type=\'password\']').clear

    driver.find_element(
      :css,
      'input[type=\'password\']'
    ).send_keys(Config::PASSWORD)

    driver.find_element(:css, '.auth > div:nth-child(4)').click

    import_css = 'div.center:nth-child(1) > div:nth-child(4) > '\
                'div:nth-child(1) > div:nth-child(2) > span:nth-child(1)'

    driver.find_element(:css, import_css).click

    spreadsheet_css = 'div.center:nth-child(1) > div:nth-child(3) > '\
                      'span:nth-child(1)'

    driver.find_element(:css, spreadsheet_css).click

    output_path = '/Users/royce/Desktop/Anki Generated Sources/'
    fullfilename = LatestFileFinder.new(output_path, '*.tsv').find
    puts fullfilename

    filename = fullfilename[
      fullfilename.rindex('/') + 1...fullfilename.rindex('.')
    ]

    driver.find_element(:name, 'deckFile').clear
    driver.find_element(:name, 'deckFile').send_keys fullfilename

    driver.find_element(:name, 'deckName').clear
    driver.find_element(:name, 'deckName').send_keys filename

    driver.find_element(:xpath, '//form/div/div/div[2]/div').click

    begin
      sleep 5
      alert = driver.switch_to.alert
      alert.accept
    rescue
      puts('WARNING: Did not find alert')
    end

    sleep 5

    puts 'Success!'
    driver.quit
  end
end
# :nocov:
