#!/usr/bin/env jruby
require 'rubygems'
require 'bundler/setup'
require 'diametric'

require 'sinatra'
if development?
  require 'sinatra/reloader'
  set :bind, '0.0.0.0'
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
  @pizza_shop = PizzaShop.new # Instantiate a new pizza shop
  @pizza_shop = PizzaShop.all.first # Set it to the first shop in the db
  erb :index
end

# post '/' do
#   @first_name, @last_name = params[:post].values_at(:first_name, :last_name)
#   @title = "#{@first_name}"
#   erb :hello
# end

__END__
@@ index
<% if @pizza_shop %>
<p> <%= "There's a good place called #{@pizza_shop.name}" %> </p>
<% else %>
<p> <%= "Could not lookup pizza shops" %> </p>
<% end %>
