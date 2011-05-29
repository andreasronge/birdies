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

  get '/users' do
    content_type :json
    users
    # users.collect{ |u| { :name => "@#{u[:twid]}", :link => "/user/#{u[:twid]}", :value => u[:tweeted]}}.to_json
    #@birds.users.collect{ |u| { :name => "@"+u.twid, :link => "/user/#{u.twid}", :value => u.outgoing(:TWEETED).size }}.to_json
  end

  get '/user/:id' do |id|
    # user with :KNOWS, :TWEETED, :USED
    @user = user(id)
    erb :user
  end

  get '/tag/:id' do |id|
    @tag = @birds.tag(id)
    erb :tag
  end

  get '/tags' do
    content_type :json
    tags
    #@birds.tags.collect{ |t| { :name => "#"+t.name, :link => "/tag/#{t.name}", :value => t.incoming(:TAGGED).size } }.to_json
  end

  post '/update' do
    @tags = @params["tag"].split
    puts "UPDATE #{@params.inspect}, tags #{@tags.inspect}"
    #@tags << "neo4j" unless @tags.include? "neo4j"
    update_tweets(@tags)
    redirect "/"
  end
end
