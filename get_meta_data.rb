# このrubyファイルは一つのurlを広告ありなしで判断するためのものです。
require 'open-uri'
require 'nokogiri'
require 'byebug'
require './scrape_with_things'

def fetch_number_ad_apps(url)
  urls = get_other_apps_url(url)
  num_app = count_ad_apps(urls)
  return num_app
end


# return url array related to the app
def get_other_apps_url(url)
  developper_url = check_developper(url)
  dev_page = Nokogiri::HTML(open(developper_url).read)
  tmp = dev_page.search('.card-click-target')
  apps_arr = Array.new(dev_page.search('a.card-click-target'))
  urls = []
  for i in apps_arr do
    tmp = i.attribute('href').value
    tmp = modify_link(tmp)
    urls << tmp
  end
  urls = urls.uniq
  self_url = $self_url.gsub(/https:..play.google.com/,'')
  #here
  urls.include?(self_url)
  return urls
end

# return developper's url
def check_developper(url)
  $self_url = url
  $html_doc = Nokogiri::HTML(open(url).read)
  tmp  = $html_doc.search('.document-subtitle.primary')
  # developper = tmp[0].attribute('href').value.split(/^(\/)store\/apps\/developer\?id=(.+)/)[2]
  dev_url = tmp[0].attribute('href').value
  return modify_link(dev_url)
end

def modify_link(url)
  url = 'https://play.google.com' + url
  return url
end

def use_scraping(url)
  $html_doc = Nokogiri::HTML(open(url).read)
  app_title = $html_doc.search('.id-app-title').inner_text
  # スラッシュが入っていた場合アンダーバーへ変更する。
  app_title.gsub!("/",'_') if app_title.include? "/"
  # 広告があるかないかで分岐させます。
  tmp_check_ad = $html_doc.search('.ads-supported-label-msg').inner_text
  if tmp_check_ad.include? "広告を含む"
    # app_titleに対応したフォルダを作ります。
    unless File.exists?("広告あり/apps/#{app_title}")
      Dir.mkdir("広告あり/apps/#{app_title}")

      # 作成されたフォルダの下にレビューを保存します。
      File.open("広告あり/apps/#{app_title}/reviews.txt","w+") do |f|
        $html_doc.search('.review-body.with-review-wrapper').each do |review|
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
        $html_doc.search('.review-body.with-review-wrapper').each do |review|
          f.puts(review.inner_text.delete "全文を表示")
        end
      end
      print('保存されました。')
    else
      print('既にフォルダが作成されています。')
    end
  end
end










