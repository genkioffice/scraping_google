# このrubyファイルは一つのurlを広告ありなしで判断するためのものです。
require 'open-uri'
require 'nokogiri'
require 'byebug'


# in the file in fancs, i can get the list of apps made by same developper.
# A contains the list
# you can just add first column in google_review_text.
#you can search by app-name in the directory
# then A is creaated by the app you've chosen
# so there are 2 files or functions are needed
# 1: count added app
# 2: add it to the google_review_array
def count_ad_apps(arr)
  app_count = 0
  for i in arr
    app_count += check_add(i)
  end
  return app_count
end

def check_add(url)
  html_doc = Nokogiri::HTML(open(url).read)
  app_title = html_doc.search('.id-app-title').inner_text
  # スラッシュが入っていた場合アンダーバーへ変更する。
  app_title.gsub!("/",'_') if app_title.include? "/"
  # 広告があるかないかで分岐させます。
  tmp_check_ad = html_doc.search('.ads-supported-label-msg')
  boo = html_doc.xpath('//span[contains(@class,"ads-supported-label-msg")]').inner_text.include? "広告を含む"
  if boo
    return 1
  else
    return 0
  end
end
