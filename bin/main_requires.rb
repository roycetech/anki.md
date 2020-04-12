require './lib/class_extensions'
require 'pry'
require 'pry-nav'
require 'dotenv/load'

# The requires below need to be reviewed...

require 'active_support/concern'
require 'active_support/inflector'

require './lib/tag_helper'

require './lib/utils/oper_utils'
require './lib/utils/regexp_utils'
require './lib/utils/html_utils'
require './lib/markdown'
require './lib/html_generator'

require './lib/reviewer'
require './lib/source_reader'
require './lib/meta_reader'
require './lib/latest_file_finder'
require './lib/source_parser'
require './lib/tag_counter'

UNIT_TEST = false unless defined?(UNIT_TEST)

require './bin/upload' unless UNIT_TEST
require './lib/mylogger'
require 'CSV'

require './lib/system_tag_counter'
require './bin/helper/card_printer'
