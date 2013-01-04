#!/usr/bin/ruby

require 'steam-condenser'
require 'pp'
require 'rubberband'

@es = ElasticSearch::Client.new('127.0.0.1:9200', :index => 'test')


id = SteamId.new('thesteamuser')

puts "GAMES"

id.games.each do |g,k|
    puts "indexing " + g.to_s + " " + k.name 
    @es.index({:name => k.name, :short_name => k.short_name}, :id => g, :type => 'game')
end

#id.friends.each do |f|
#    puts f
#end
