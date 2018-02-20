require 'open-uri'
require 'nokogiri'
require './get_meta_data'


# for dev
puts 'enter your url: '
# url = gets.chomp
url = 'https://play.google.com/store/apps/details?id=jp.smarteducation.tofusushi'
count_ad_app(url)