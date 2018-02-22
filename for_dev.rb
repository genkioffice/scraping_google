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
  begin
	  html_doc = Nokogiri::HTML(open(url).read)
	  tmp = html_doc.search('.document-subtitle.category')
	  genre = tmp.search(".document-subtitle.category").attribute("href").value.split(/^(\/)store\/apps\/category\/(.+)/)[2]
	  genre_num = check_value_from_string(genre)
  rescue => error
  	genre_num = 58
  end
  return genre_num
end



# used in get_category function
def check_value_from_string(category)
  return @genre.find_index {|i,d| d == category}
end



url = "https://play.google.com/store/apps/details?id=com.selvas.fr"
g = get_category(url)
p g
