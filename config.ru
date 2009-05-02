
require 'rubygems'
require 'sinatra'

Sinatra::Application.set(
  :run => false,
  :environment => :production
)

require 'peep.rb'
run Sinatra.application