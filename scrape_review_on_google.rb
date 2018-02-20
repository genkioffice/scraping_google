# このrubyファイルは一つのurlを広告ありなしで判断するためのものです。
require 'open-uri'
require 'nokogiri'
# require 'byebug'



def use_scraping(url)
  html_doc = Nokogiri::HTML(open(url).read)
  app_title = html_doc.search('.id-app-title').inner_text
  # スラッシュが入っていた場合アンダーバーへ変更する。
  app_title.gsub!("/",'_') if app_title.include? "/"
  # 広告があるかないかで分岐させます。
  tmp_check_ad = html_doc.search('.ads-supported-label-msg').inner_text
  if tmp_check_ad.include? "広告を含む"
    # app_titleに対応したフォルダを作ります。
    unless File.exists?("広告あり/apps/#{app_title}")
      Dir.mkdir("広告あり/apps/#{app_title}")
      
      # 作成されたフォルダの下にレビューを保存します。
      File.open("広告あり/apps/#{app_title}/reviews.txt","w+") do |f|
        html_doc.search('.review-body.with-review-wrapper').each do |review|
          f.puts(review.inner_text.delete "全文を表示")
        end
      end
      print('保存されました。')
    else
      print('既にフォルダが作成されています。')
    end
  else
    unless File.exists?("広告なし/apps/#{app_title}")
      Dir.mkdir("広告なし/apps/#{app_title}")

      # 作成されたフォルダの下にレビューを保存します。
      File.open("広告なし/apps/#{app_title}/reviews.txt","w+") do |f|
        html_doc.search('.review-body.with-review-wrapper').each do |review|
          f.puts(review.inner_text.delete "全文を表示")
        end
      end
      print('保存されました。')
    else
      print('既にフォルダが作成されています。')
    end
  end
end
