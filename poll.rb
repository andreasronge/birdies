require 'rubygems'
require 'neography'

Neography::Config.server = ENV['NEO4J_HOST'] || 'localhost'
Neography::Config.port =  (ENV['NEO4J_PORT'] || "7474").to_i
Neography::Config.authentication = 'basic'
Neography::Config.username = ENV['NEO4J_LOGIN']
Neography::Config.password = ENV['NEO4J_PASSWORD']

require 'birds'

while true 
  birds = Birds::Birds.new
  begin 
    birds.update(["jaxcon"])
  rescue => e
    puts e
  end
  sleep 120
end