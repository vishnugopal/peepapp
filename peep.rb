require 'rubygems'
require 'sinatra'

require 'starling'
require 'json'

starling = Starling.new 'localhost:22122' #for worker data
memcache = MemCache.new 'localhost:11211' #for master data

post '/worker_send' do
  queue_name = "worker_to_master_#{params[:job]}"
  starling.set(queue_name, params.to_json)
  params.inspect.to_s
end

post '/worker_receive' do
  key_name = "master_to_worker_#{params[:job]}"
  memcache.get(key_name)
end

post '/master_send' do
  key_name = "master_to_worker_#{params[:job]}"
  memcache.set(key_name, params.to_json)
  params.inspect.to_s
end

post '/master_receive' do
  queue_name = "worker_to_master_#{params[:job]}"
  data = []
  while starling.sizeof(queue_name) > 0
    data << starling.get(queue_name)
  end
  data.to_json
end