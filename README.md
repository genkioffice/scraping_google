# scraping_google
these programs here is to scrape reviews in google play store. You can put a url of an app on use use_scrape function in 'scrape_review_on_google.rb.'

<h1>Example </h1>
Here is an example to use it.
In run_scraping.rb, I defined like:

```
require './scrape_with_things'

print('enter url')
url = gets.chomp
use_scraping(url)
```

You might enter url like:
```
https://play.google.com/store/apps/details?id=com.sonymobile.themes.valentines
```

and get return: XPERIA™ Valentine’s Theme
