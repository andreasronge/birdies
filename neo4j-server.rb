require 'net/http'

module Neo4jServer

  module ClassMethods

    def server_url=(url)
      @server_url = URI.parse(url)
    end

    def server_url
      @server_url || URI.parse('http://localhost:7474')
    end


    def update_tweets(tweets)
      result = Neo4jServer.eval "BirdiesBackend.update_tweets(#{tweets})"
      JSON.parse(result)['changed']
    end

    def eval(s)
      res = Net::HTTP.start(server_url.host, server_url.port) do |http|
        http.post('/script/jruby/eval', s)
      end
      [res.code, res.body]
    end

  end

  extend ClassMethods

end
