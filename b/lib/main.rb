require 'sinatra'
require 'sinatra/cors'
require 'json'
require 'pstore'

set :allow_origin, "http://localhost:3000"
set :allow_methods, "GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS"
set :allow_headers, "content-type,if-modified-since,allow-origin,authorization"
set :expose_headers, "location,link"
set :allow_credentials, true

# API
before '/*' do
  if ['POST', 'DELETE'].include? request.request_method then
    ['Bearer nicepass'].include? request.env['HTTP_AUTHORIZATION'] or halt 401
  elsif not ['OPTIONS'].include? request.request_method then
    ['Bearer passpass'].include? request.env['HTTP_AUTHORIZATION'] or halt 401
  end
  response.headers['Content-Type'] = 'application/json'
  @store = PStore.new './db'
end

get '/api/clients' do
  result = @store.transaction do
    @store['clients']
  end  
  result.to_json
end

before '/api/clients/:id' do
  @store.transaction do
    if not ['POST', 'DELETE'].include? request.request_method then
      @store['clients'].key? params['id'] or halt 401
    end
  end
end

get '/api/clients/:id' do
  result = @store.transaction do
     @store['clients'][params['id']]
  end
  result.to_json
end

post '/api/clients' do
  result = @store.transaction do
    request.body.rewind
    data = (JSON.parse request.body.read).transform_values {|v| v.to_s}
    id = data["id"]
    detail = {}.merge(data.slice "ip", "port", "name")
    id or halt 401
    @store['clients'][id] and halt 401
    @store['clients'][id] = detail
    @store['clients'][id]
  end
  result.to_json
end

patch '/api/clients/:id' do
  result = @store.transaction do
    request.body.rewind
    old = @store['clients'][params['id']]
    new = ((JSON.parse request.body.read).transform_values {|v| v.to_s}).slice "ip", "port"
    @store['clients'][params['id']] = old.merge new
    @store['clients'][params['id']]
  end
  result.to_json
end

delete '/api/clients/:id' do
  result = @store.transaction do
    client = @store['clients'][params['id']]
    client or halt 404
    @store['clients'].delete params['id']
    client
  end
  result.to_json
end
