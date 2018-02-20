require 'open-uri'
require 'nokogiri'
require './scrape_googleplay'


puts('googleのカテゴリページのurlを入力してください')
url = gets.chomp
html_doc = Nokogiri::HTML(open(url).read)

html_doc.search('a.see-more').each do |page|
  url = "https://play.google.com" + page.attr('href')
  html_doc.search('a.title').each do |app|
  	url = "https://play.google.com" + app.attr('href')
  	use_scraping(url)	
  end
  puts('ページ内の仕分けを完了しました。')
end
puts('カテゴリ内の仕分けを完了しました。')
