require 'rubygems'
require 'uri'
require 'twitter'
require 'json'
require 'rest-client'
require 'neo4j-server'

module Birds

  def users(*)
    _server_call("BirdiesBackend", 'users')
  end

  def tags(*)
    _server_call("BirdiesBackend", 'tags')
  end

  def user(id)
    _server_call("BirdiesBackend", 'user', id)
  end

  def tag(id)
    _server_call("BirdiesBackend", 'tag', id)
  end

  def tweet(tweet_id)
    _server_call("BirdiesBackend", 'tweet', tweet_id)
  end

  def update_tweets(tags)
    search = Twitter::Search.new
    puts tags.inspect
    tags.each { |tag| search.hashtag(tag) }
    puts "UPDATE TWEETS"
    added = []
    while (!(new_tweets = _update_tweets(search.fetch_next_page)).empty?)
      new_tweets.each{|t| puts "ADD #{t}"; added << t}
    end
    puts "got added #{added.inspect}"
    added
  end

  def server_url=(url)
    @server_url = url
  end

  def server_url
    @server_url || 'http://localhost:7474'
  end


  def _update_tweets(tweets)
    return [] if tweets.nil?
    result = _server_call('BirdiesBackend', 'update_tweets', tweets.to_json)
    result['tweets'] || []
  end

  def _server_call(clazz, method, *args)
    params = {:class => clazz, :method => method, :args => args.size}
    args.each_with_index{|v, index| params.merge!({"arg#{index}" => v})}

    url = URI.join(server_url, "/script/jruby/call").to_s
    response = RestClient.post(url, params)
    raise "Error #{response.code} on '#{url}'" unless response.code == 200
    s = response.to_str.to_s.clone
    parsed = JSON.parse(s)
    puts "RETURN #{parsed.inspect}"
    parsed['return']
  end

   # application/x-www-form-urlencoded

end
