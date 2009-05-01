require 'rubygems'
require 'sinatra'

require 'starling'

starling = Starling.new('127.0.0.1:22122')

get '/post/*' do
  starling.set("love", params[:splat].to_s)
  "STORED"
end

get '/get' do
  starling.get("love") if starling.sizeof("love") > 0 
end