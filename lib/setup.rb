require 'msgpack'
require 'set'
require './lib/store.rb'
require './lib/helpers.rb'

Dir.exists? './db' or Dir.mkdir('./db')
File.file?('./db/ix') or File.write('./db/ix', [].to_msgpack)
store = Store.new './db/ix'

store.read.each do |id|
  path = build_path('./db', id)
  File.file?(path) or File.write(path, {}.to_msgpack)
end

