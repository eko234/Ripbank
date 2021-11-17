require 'sinatra'
require 'yaml/store'
require 'json'

db_path = './db.yaml'

# API
before '/api/*' do
  @store = YAML::Store.new db_path
end

get '/api/clients' do
  result = @store.transaction do
    @store['clients']
  end
  result
end

put '/api/clients/:client_id' do
  result = @store.transaction do
    request.body.rewind
    old = @store['clients'][params['client_id']]
    new = (JSON.parse request.body.read).slice "ip", "port"
    @store['clients'][params['client_id']] = old.merge new
    @store['clients'][params['client_id']]
  end
  [:ok, result].to_json
end

# PAGES
get '/' do
  "<h1> RIP </h1>"
end

before '/:client_id' do
  @store = YAML::Store.new db_path
  @store.transaction do
    @store['clients'].key? params['client_id'] or error 'Invalid id'
  end
end

get '/:client_id' do
  result = @store.transaction do
    @store['clients'][params['client_id']]
  end
  ip = result['ip']
  port = result['port']
  "<a href=\"http://#{ip}\" target=\"_blank\" > link </a>"
end
