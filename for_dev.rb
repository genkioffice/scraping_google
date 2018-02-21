require 'open-uri'
require 'nokogiri'
require 'byebug'
require 'addressable/uri'
require './get_meta_data'
require_relative '定数/constants.rb'


path_with = "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告あり" + "/apps"

def get_name_list(path)
	name_list = []
	Dir.foreach(path) do |f|
		unless f.start_with? "."
			name_list << f
		end
	end
	return name_list
end


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


# list_with = get_name_list(path_with)
# create_sets_url(list_with)


path_with = "/Users/g_takahashi/data_science/scraping/scraping_google" + "/広告あり" + "/apps"


def convert_path_to_link(path)
	path_list = get_name_list(path)
	urls = create_sets_url(path_list)
	return urls
end

# get_category('https://play.google.com/store/apps/details?id=com.coffeebeanventures.easyvoicerecorder')




## ここで、ジャンルを数値として取れるので、これを組み込むこと!
def get_category(url)
  html_doc = Nokogiri::HTML(open(url).read)
  tmp = html_doc.search('.document-subtitle.category')
  genre = tmp.search(".document-subtitle.category").attribute("href").value.split(/^(\/)store\/apps\/category\/(.+)/)[2]
  genre_num = check_value_from_string(genre)
  return genre_num
end

def check_value_from_string(category)
  return @genre.find_index {|i,d| d == category}
end

url = "https://play.google.com/store/apps/details?id=com.microsoft.office.outlook"

category = get_category(url)
byebug
a = @genre.find_index {|i,d| d == category}
byebug
p 3

