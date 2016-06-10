require "bundler/gem_tasks"
require 'rake/testtask'
require 'wampa'

Dir.glob('tasks/*.rake').each { |r| import r }

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/*_test.rb"
end

task :default => :test
