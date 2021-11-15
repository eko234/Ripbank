require './lib/store'
require 'rake'

task :run do
  ruby './lib/main.rb'
end

task :setup do
  ruby './lib/setup.rb'
end

task :add, [:db] do |t, args|
  store = Store.new './db/ix'
  ix = store.read
  ix.include? args[:db] or ix.push args[:db]
  store.write ix
end
