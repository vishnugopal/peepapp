
require 'httparty'

PeepError = Class.new(StandardError)

class Peep
  attr_accessor :job
  
  include HTTParty
  base_uri "peepapp.com"
  
  def initialize(params = {}) 
    self.job = params[:job] || ""
    raise PeepError, "Job is blank" if job.blank?
  end
  
  def send(params = {})
    params.merge!(:job => job)
    options = { :query => params }
    post('/master_send', options)
  end
  
  def receive(params = {})
    params.merge!(:job => job)
    options = { :query => params }
    post('/master_receive', options)
  end
  
  def post(path, options)
    begin
      self.class.post(path, options)
    rescue Errno::ETIMEDOUT, Errno::ENETUNREACH, Timeout::Error, 
           Errno::ECONNRESET, SocketError
      sleep 5 and retry
    end
  end
  
end