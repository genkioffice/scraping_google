
require 'open-uri'
require 'nokogiri'
require './get_meta_data'


puts('enter an app url on google play store')
url = gets.chomp
n = fetch_number_ad_apps(url)
puts('the number of apps with advertsement: ' + (n).to_s)
