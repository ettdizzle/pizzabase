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

# _Load models_ #
# Could load all in /models but we'll do each one explicitly for now.
# I would also be okay with one models.rb file, but convention seems
#   to be to put each entity in its own file.
require 'models/person' # Person
require 'models/town' # Town
require 'models/pizza_shop'# PizzaShop

# _Handlers_
get '/' do
  @title = "Hello"
  @pizza_shop = PizzaShop.all.first
  erb :index
end

get '/view/pizza-shops' do
  @title = "Pizza Shops"
  @pizza_shops = PizzaShop.all
  erb :view_pizza_shops
end

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

__END__
@@ index
<% if @pizza_shop %>
<p> <%= "There's a good place called #{@pizza_shop.name}" %> </p>
<% else %>
<p> <%= "Could not lookup pizza shops" %> </p>
<% end %>
