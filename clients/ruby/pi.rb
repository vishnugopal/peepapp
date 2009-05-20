
require 'rubygems'
require 'json'
require 'peep/core'
require 'peep/utils/bigdecimal'


$silent = false
$debug = false
$job = "peep_pi"

def out(message)
  puts "#{Time.now}: #{message}" unless $silent
end

def outd(message)
  out(message) if $debug
end

count_within_circle = 0.b
count = 0.b

peep = Peep.new :job => $job

peep_strength = []

while true
  out "Checking for new data #{count_within_circle}/#{count}..."
  data = peep.receive
  sleep 5 and next if data.nil?

  outd "Data: #{data.inspect.to_s}"
  
  data = JSON.parse(data)
  outd "Data parsed: #{data.inspect.to_s}"
  if data.length > 0
    out "New data found: #{data.length} records."
  end
  
  data.each do |datum|
    datum = JSON.parse(datum)
    outd "Processing count_within: #{datum['count_within_circle']} count: #{datum['count']}"  
    count_within_circle += datum['count_within_circle'].b
    count += datum['count'].b
  end

  if data.length > 0
    peep_strength << data.length
    average_peep_strength = (peep_strength.inject(0) { |a, b| a + b }) / peep_strength.length
    
    outd "Calculating new value of PI..."
    pi = 4 * (count_within_circle / count)  
    out "PI value is: #{pi}"

    outd "Sending value of PI and statistics..."
    peep.send :pi => pi, :peep_strength => average_peep_strength
    outd "Done."
  end
  
  sleep 5
end
  