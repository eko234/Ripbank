require 'rake'
require 'yaml/store'

task :run do
  ruby './lib/main.rb'
end

task :setup do
  db = YAML::Store.new './db.yaml'
  db.transaction do
    db['clients']= {}
  end
end
