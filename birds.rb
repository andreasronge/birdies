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
    @server_url = url
  end

  def server_url
    @server_url || 'http://localhost:7474'
  end


  def _update_tweets(tweets)
    return false if tweets.nil?
    puts "_update_tweets '#{tweets}'"
    result = _server_call('BirdiesBackend', 'update_tweets', tweets.to_json)
    puts "got result '#{result}'"
    JSON.parse(result)['return']
  end

  def _server_call(clazz, method, *args)
    params = {:class => clazz, :method => method, :args => args.size}
    args.each_with_index{|v, index| params.merge!({"arg#{index}" => v})}

    url = URI.join(server_url, "/script/jruby/call").to_s
    puts "CALL '#{url}'"
    puts "PARAMS #{params.inspect}"
    response = RestClient.post(url, params)
    raise "Error #{response.code} on '#{url}'" unless response.code == 200
    response.to_str
  end

   # application/x-www-form-urlencoded

end
