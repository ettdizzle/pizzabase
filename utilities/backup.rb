#!/usr/bin/env jruby
require '../app'

PizzaShop.all.each do |ps|
  puts [ps.name, "#{ps.location.name}, #{ps.location.state}",
        ps.phone, ps.quality].join('|')
end
