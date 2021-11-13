require 'msgpack'
require 'json'

class StorePathProtector
  def initialize(valid_paths)
    @valid_paths = valid_paths
  end

  def protect(path)
    @valid_paths.include? path or raise "INVALID PATH"  
  end
end

class Store
  def initialize(path_protector)
    @path_protector = path_protector
  end

  def protect(path:)
    @path_protector.protect path
  end
  
  def create(path:)
    protect(path: path)
    File.write(path, {}.to_msgpack) 
  end
  
  def read(path:)
    protect(path: path)
    file = File.open(path)
    MessagePack.unpack(file.read)
  end

  def write(path:, data:)
    protect(path: path)
    File.write(path, data.to_msgpack)
  end
end

bank = Store.new(StorePathProtector.new(["ses"]))
bank.create(path: "sus")
