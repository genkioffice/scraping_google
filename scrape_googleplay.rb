# このrubyファイルは一つのurlを広告ありなしで判断するためのものです。
require 'open-uri'
require 'nokogiri'
require './scrape_review_on_google'

puts('googleストアのアプリ一覧ページのurlを入力してください。')
url = gets.chomp
html_doc = Nokogiri::HTML(open(url).read)

html_doc.search('a.title').each do |app|
  url = "https://play.google.com" + app.attr('href')
  use_scraping(url)
end
puts('ページ内の仕分けを完了しました。')
