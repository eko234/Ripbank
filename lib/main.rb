require 'sinatra'
require './lib/store.rb'
require'./lib/helpers.rb'
require 'json'

db_path = './db'
ix_path = "#{db_path}/ix"


before '/clients/:client_id/*' do
  puts params
  ix = Store.new(ix_path).read
  puts ix
  puts params['client_id']
  store_path_protector = StorePathProtector.new(ix.map {|id| build_path(db_path, id)})
  @store = Store.new(build_path(db_path, params['client_id']), store_path_protector)
end

get '/clients/:client_id/ip' do
  [:ok, @store.read].to_json
end

put '/clients/:client_id/ip' do
  request.body.rewind
  entry = @store.read
  updated_entry = entry.merge(JSON.parse request.body.read).select {|f| ['ip'].include? f}
  @store.write(updated_entry)
  [:ok, nil].to_json
end
