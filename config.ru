
require 'rubygems'
require 'sinatra'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)

require 'peep.rb'
run Sinatra.application