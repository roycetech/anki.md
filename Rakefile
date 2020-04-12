require 'rake/testtask'
require 'pry'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test*.rb']
  # t.test_files = FileList['tests/test_single.rb']
  t.verbose = true
end

task default: [:run]

task :run do
  ruby './main_script.rb'
end

# To run: 'rake rspec[./lib/myruby.rb]'
# Creates a spec file from a ruby file.
task :rspec, [:filename] do |_t, args|
  puts "Args were: #{args[:filename]}"
  ruby "./bin/spec_maker.rb #{args[:filename]}"
end

task :runpload do
  ruby './main_script.rb upload'
end

task :multi, [:wildcard] do |_t, args|
  puts "Args were: #{args}"
  ruby "./bin/main_class.rb #{args[:wildcard]}"
end

task :tag do
  ruby './bin/api_source_tagger.rb'
end

task :stat do
  ruby './bin/card_counter.rb'
end

task :upload do
  ruby './bin/upload.rb'
end

task :collect do
  ruby './bin/collect_important_api.rb'
end
