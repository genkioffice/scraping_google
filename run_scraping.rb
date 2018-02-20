
require 'open-uri'
require 'nokogiri'
require './get_meta_data'
require './scrape_with_things'

print('enter url')
# url = gets.chomp
url_with = 'https://play.google.com/store/apps/details?id=vg.cakejam.TreasureHuntCleopatra'
url_without = 'https://play.google.com/store/apps/details?id=jp.gungho.padRadar'
a = check_add(url)
c = 10
puts(c)
puts(c + a)