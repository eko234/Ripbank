require 'rake'
require 'pstore'

task :run do
  ruby './lib/main.rb'
end

task :setup do
  db = PStore.new './db'
  db.transaction do
    db['clients']= {}
  end
end

task :register , [:client] do |t, args|
  db = PStore.new './db'
  db.transaction do
    db['clients'][args[:client]] = {}
  end
end 
