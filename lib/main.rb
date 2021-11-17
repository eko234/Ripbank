require 'sinatra'
require 'json'
require 'pstore'

db_path = './db'

# API
before '/api/*' do
  request.headers['Authorization'] == 'Bearer passpass' or halt 401  
  response.headers['Content-Type'] = 'application/json'
  @store = PStore.new db_path
end

get '/api/clients' do
  result = @store.transaction do
    @store['clients']
  end  
  result.to_json
end

before '/api/clients/:client_id' do
  result = @store.transaction do
    @store['clients'].key? params['client_id'] or error 'Invalid id'
  end
  result.to_json
end

get '/api/clients/:client_id' do
  result = @store.transaction do
     @store['clients'][params['client_id']]
  end
  result.to_json
end

patch '/api/clients/:client_id' do
  result = @store.transaction do
    request.body.rewind
    old = @store['clients'][params['client_id']]
    new = (JSON.parse request.body.read).slice "ip", "port"
    @store['clients'][params['client_id']] = old.merge new
    @store['clients'][params['client_id']]
  end
  result.to_json
end
