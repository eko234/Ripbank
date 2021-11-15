require 'msgpack'

class StorePathProtector
  def initialize(valid_paths)
    @valid_paths = valid_paths
  end

  def protect(path)
    @valid_paths.include? path or raise "INVALID PATH"  
  end
end

class Store
  def initialize(path, store_path_protector=nil)
    @store_path_protector = store_path_protector
    @path = path
  end

  def protect
    @store_path_protector ? (@store_path_protector.protect @path) : nil 
  end
  
  def create
    protect
    File.write(@path, {}.to_msgpack) 
  end
  
  def read
    protect
    file = File.open(@path)
    MessagePack.unpack(file.read)
  end

  def write(data)
    protect
    File.write(@path, data.to_msgpack)
  end
end
