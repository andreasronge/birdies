require 'rubygems'
require 'neography'
require 'uri'
require 'twitter'
require 'json'
require 'rest-client'
require 'neo4j-server'

module Birds

  def users(*)

  end

  def tags(*)

  end
  def update_tweets(tags)
    search = Twitter::Search.new
    puts tags.inspect
    tags.each { |tag| search.hashtag(tag) }
    puts "UPDATE TWEETS"
    while (_update_tweets(search.fetch_next_page))
    end
  end

  def server_url=(url)
    @server_url = URI.parse(url)
  end

  def server_url
    @server_url || URI.parse('http://localhost:7474')
  end


  def _update_tweets(tweets)
    return false if tweets.nil?
    puts "_update_tweets '#{tweets}'"
    result = _server_call('BirdiesBackend', 'update_tweets', tweets.to_json)
    puts "got result '#{result}'"
    JSON.parse(result)['return']
  end

  def _server_call(clazz, method, value)
    url = "/script/jruby/call?classandmethod=#{clazz}.#{method}"
    res = Net::HTTP.start(server_url.host, server_url.port) do |http|
      http.post(url, value)
    end
    raise "Error #{res.code} on '#{url}'" unless res.code == '200'
    res.body
  end


end
