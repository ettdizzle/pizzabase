#!/usr/bin/env jruby
require 'rubygems'
require 'bundler/setup'

require 'sinatra'
if development?
  require 'sinatra/reloader'
  set :bind, '0.0.0.0'
end

# _App-wide settings_
# set is like attr_accessor for settings class
# e.g, settings.app_name to call from anywhere
set :app_name, "PizzaBase"

# _Handlers_
get '/' do
  @title = "Hello"
  erb '<p>Hi from PizzaBase!</p>'
end

# post '/' do
#   @first_name, @last_name = params[:post].values_at(:first_name, :last_name)
#   @title = "#{@first_name}"
#   erb :hello
# end
