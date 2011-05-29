require 'rubygems'
require 'sinatra/base'
require 'uri'
require 'birds'


class App < Sinatra::Base
  set :haml, :format => :html5 
  set :app_file, __FILE__
  set :static, true
  set :root, File.dirname(__FILE__)
  set :views, File.join(File.dirname(__FILE__), "views")
  set :public, File.join(File.dirname(__FILE__), "public")

  include Birds

  get '/' do
    erb :index
  end

  get '/tweet/:id' do |tweet_id|
    @tweet = tweet(tweet_id)
    erb :tweet
  end

  get '/users' do
    content_type :json
    users
    # users.collect{ |u| { :name => "@#{u[:twid]}", :link => "/user/#{u[:twid]}", :value => u[:tweeted]}}.to_json
    #@birds.users.collect{ |u| { :name => "@"+u.twid, :link => "/user/#{u.twid}", :value => u.outgoing(:TWEETED).size }}.to_json
  end

  get '/user/:id' do |id|
    @user = user(id)
    puts "GOT USER #{@user}"
    erb :user
  end

  get '/tag/:id' do |id|
    @tag = tag(id)
    puts "GOT #{@tag.inspect}"
    erb :tag
  end

  get '/tags' do
    content_type :json
    tags
  end

  post '/update' do
    @tags = @params["tag"].split
    @added = update_tweets(@tags)
    erb :updated
      # redirect "/" does not work since the instance variable @added is not available, use rack-flash to send strings using session
  end
end
