#!/usr/bin/env jruby
require 'rubygems'
require 'bundler/setup'
require 'diametric'

require 'sinatra'
if development?
  require 'sinatra/reloader' # Shotgun and Reload do not work on JVM; use this instead
  set :bind, '0.0.0.0' # This is so I can access the development server on a remote host
end

# _App-wide settings_
# set is like attr_accessor for settings class
# e.g, settings.app_name to call from anywhere
set :app_name, "PizzaBase"
# _Datomic settings_
set :db_name, "sample"
set :db_uri, "datomic:free://localhost:4334/#{settings.db_name}"

# Connect to database
@conn = Diametric::Persistence::Peer.connect(settings.db_uri)

# Sinatra settings
configure do
  set :root, File.expand_path(File.dirname(__FILE__))
end
# Can't pass settings into models, so using a constant
ROOT = settings.root

# _Load models_ #
models = %w(person town pizza_shop)
models.each do |model|
  require "#{settings.root}/models/#{model}"
end

# _Handlers_
get '/' do
  @title = "Welcome to PizzaBase"
  erb "<h2>All your pizza are belong to us</h2>"
end

# See all pizza shops
get '/view/pizza-shops' do
  @title = "All Pizza Shops"
  @pizza_shops = PizzaShop.all
  erb :view_pizza_shops
end

# Add a pizza shop
get '/add/pizza-shop' do
  @title = "Add Pizza Shop"
  @states = Town.states
  @quality_options = PizzaShop.quality_options
  erb :add_pizza_shop
end

post '/add/pizza-shop' do
  @title = "Added Pizza Shop" 
  @name, @city, @state, @quality, @phone = params[:post].values_at(:name, :city, :state, :quality, :phone)
  # Look for town. Create new town if it doesn't exist in dB
  @town = Town.where(:name => @city, :state => @state).first
  unless @town
    @town = Town.new(:name => @city, :state => @state)
    @town.save
  end
  # Create new pizza shop and save
  # TODO: See if the pizza shop already exists
  @new_pizza_shop = PizzaShop.new(:name => @name, :location => @town, :quality => @quality, :phone => @phone)
  if @new_pizza_shop.save
    erb "<p>Pizza shop saved!</p>"
    # TODO: Add link to view pizza shop list
  else
    erb "<p>It didn't work.</p>"
  end
end

# Search pizza shops
get '/find/pizza-shops' do
  @title = "Find Pizza Shops"
  @states = Town.states
  @quality_options = PizzaShop.quality_options
  erb :find_pizza_shops
end

post '/find/pizza-shops' do
  @title = "Matching Pizza Shops" 
  @name, @city, @state, @quality, @phone = params[:post].values_at(:name, :city, :state, :quality, :phone)

  query = Hash.new
  query[:name] = @name unless @name == ""
  query[:phone] = @phone unless @phone == "" #Stronger validation will help here
  query[:quality] = @quality if @quality
  if @city !="" && @state != ""
    @town = Town.where(:name => @city, :state => @state).first
    query[:location] = @town.dbid
  elsif @state != ""
    @towns = Town.where(:state => @state)
    query[:location] = @towns.map(&:dbid)
  end
  @pizza_shops = PizzaShop.where(query)
  erb :view_pizza_shops
end
