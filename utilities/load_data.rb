#!/usr/bin/env jruby
require '../app'

records = File.open(ARGV[0])

records.each_line do |record|
  name, city_state, phone, quality = record.chomp.split('|')
  city, state = city_state.split(',').map(&:strip)
  town = Town.where(:name => city, :state => state).first
  unless town
    town = Town.new(:name => city, :state => state)
    town.save
  end
  # Check if Pizza Shop already exists by name and location
  # Thus this script will not update quality and phone number of existing records
  unless PizzaShop.where(:name => name, :location => town.dbid).first
    pizza_shop = PizzaShop.new(:name => name, :location => town.dbid,
                               :phone => phone, :quality => quality)
    pizza_shop.save
  end
puts "Records loaded. Ctrl-C to exit." # Send SIGINT programmatically?
end
