require './scrape_review_on_google'

# require 'open-uri'
# require 'nokogiri'

# puts('googleストア内のアプリのURLを入力してください。')
# url = gets.chomp
# html_doc = Nokogiri::HTML(open(url).read)


# app_title = html_doc.search('.id-app-title').inner_text
# # app_titleに対応したフォルダを作ります。
# Dir.mkdir("apps/#{app_title}")

# # 作成されたフォルダの下にレビューを保存します。
# File.open("apps/#{app_title}/reviews.txt","w+") do |f|
#   html_doc.search('.review-body.with-review-wrapper').each do |review|
#     f.puts(review.inner_text.delete "全文を表示")
#   end
# end
# print('保存されました。')

puts($app_title)
