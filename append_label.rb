require 'open-uri'
require 'nokogiri'
require 'byebug'
# example
path_with = "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告あり" + "/apps"

# get name from directory, you have to path the returnd item to create_sets_url
def get_name_list(path)
  name_list = []
  Dir.foreach(path_with) do |f|
    unless f.start_with? "."
      name_list << f
    end
  end
  return name_list
end

# used in create_sets_url, 
def scrape_search(path)
  path = Addressable::URI.parse(path).normalize
  html_doc = Nokogiri::HTML(open(path).read)
  tmp = html_doc.search('.card-click-target')
  if tmp.empty?
    return 'deleted'
  else  
    the_url = tmp[1].attribute('href').value
    return modify_link(the_url)
  end
end

def create_sets_url(list_of_app)
  url_list = []
  for title in list_of_app
    search_tag = File.join("https://play.google.com/store/search?q=", title, "&c=apps")
    tmp = scrape_search(search_tag)
    url_list << tmp
  end
  return url_list
end

# you have to pass path of your directory and return it to the url link.
def convert_path_to_link(path)
  name_list = get_name_list(path)
  urls = create_sets_url(name_list)
  return urls, name_list
end

# enter url and return the genre of the app
def get_category(url)
  html_doc = Nokogiri::HTML(open(url).read)
  tmp = html_doc.search('.document-subtitle.category')
  genre = tmp.xpath('span',itemprop="genre").children.inner_text
  return genre
end

def 


# this is main fanction
def adapt_label()
  path_with = "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告あり" + "/apps"
  with_list, with_name_list = convert_path_to_link(path_with)
  
  path_without =  "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告なし" + "/apps"
  without_list, without_name_list = convert_path_to_link(path_without)

  # for one file
  # open file in directory
  for title in with_name_list
    File.open("広告あり/apps/#{app_title}", mode="a+") {|f|
      f.seek(0, IO::SEEK_SET)
      # genreを取り出す
      url = with_list[title]
      genre = get_category(url)
      f.puts "genre: " + genre
       
    }





  files = []
  # return title of file
  app_title = File.basename(file, ".txt")
  files.append(app_title)

  html_doc = Nokogiri::HTML(open(url).read)
  app_title = html_doc.search('.id-app-title').inner_text
  # スラッシュが入っていた場合アンダーバーへ変更する。
  app_title.gsub!("/",'_') if app_title.include? "/"

  tmp_check_category = html_doc.search('.document-subtitle.category').inner_text
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
