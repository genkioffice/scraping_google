require 'open-uri'
require 'nokogiri'
require 'byebug'
require 'addressable/uri'
require './get_meta_data'
require_relative '定数/constants.rb'

def get_name_list(path)
  name_list = []
  Dir.foreach(path) do |f|
    unless f.start_with? "."
      name_list << f
    end
  end
  return name_list
end

# used in create_sets_url, 
def scrape_search(path)
  begin
    path = Addressable::URI.parse(path).normalize
    html_doc = Nokogiri::HTML(open(path).read)
    tmp = html_doc.search('.card-click-target')
  rescue => error
    sleep 1
    puts error.message
    retry
  end
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
  genre = tmp.search(".document-subtitle.category").attribute("href").value.split(/^(\/)store\/apps\/category\/(.+)/)[2]
  genre_num = check_value_from_string(genre)
  return genre_num
end

# used in get_category function
def check_value_from_string(category)
  return @genre.find_index {|i,d| d == category}
end





# this is main fanction
def adapt_label()
  # path_with = "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告あり" + "/apps"
  # with_list, with_name_list = convert_path_to_link(path_with)
  
  # path_without =  "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告なし" + "/apps"
  # without_list, without_name_list = convert_path_to_link(path_without)
  
  path_without =  "/Users/g_takahashi/data_science/tests/scraping_google/tmp/apps"
  without_list, without_name_list = convert_path_to_link(path_without)
  
  # for title in with_name_list
  #   File.open("広告あり/apps/#{app_title}", mode="a+") {|f|
  #     f.seek(0, IO::SEEK_SET)
  #     # genreを取り出す
  #     byebug
  #     url = with_list[title]
  #     genre = get_category(url)
  #     # 他のad付きのappの数を数える
  #     ad_counts = fetch_number_ad_apps(url)
  #     f.puts "genre: " + genre
  #     f.puts "others: " + ad_counts
  #   }
  # end

  for title in without_name_list
    File.open("../../tests/scraping_google/tmp/apps/#{title}/reviews.txt", mode="a") do |f|
      f.seek(0, IO::SEEK_SET)
      # genreを取り出す
      title_index = without_name_list.find_index(title)
      url = without_list[title_index]
      genre = get_category(url)
      # 他のad付きのappの数を数える
      ad_counts = fetch_number_ad_apps(url)
      f.puts("genre: " + genre.to_s)
      f.puts("others: " + ad_counts.to_s)
    end
  end
end

adapt_label()