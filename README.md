# Twitter Data Parse for Jekyll

A quick and dirty pair of filters for [Jekyll](http://jekyllrb.com/) that parse a [Twitter CSV archive](https://support.twitter.com/articles/20170160-downloading-your-twitter-archive) and compile a list of tweet counts and basic statistics.

## Requirements
Jekyll >= 2.4.0

## Installation
Place twitter_data_parse.rb into the _plugins/ directory of your Jekyll instance.

## Usage
### Daily tweet counts
With tweets.csv in the _data/ directory of your Jekyll site installation, place the following code towards the top of your template:

    {% assign tweets = site.data.tweets | twitter_parse %}
    
This will return an array of tweets, with the following keys in each tweet object:

- **date** - The date of the record, in format YYYY-mm-dd converted to the local user's timezone
- **tweets** - The total number of tweets for that day
- **original** - The total number of tweets for that day that aren't replies or retweets
- **replies** - The total number of replies for that day
- **retweets** - The total number of retweets for that day

### Basic tweet statistics
Right below the tweet counts, place the following code:

    {% assign stats = tweets | twitter_stats %}

This will return an object with the following keys:

- **total_days** - The total number of days covered (including days with no tweets)
- **total_tweets** - The total number of tweets
- **total_originals** - The total number of originals
- **total_replies** - The total number of replies
- **total_retweets** - The total number of retweets
- **average_tweets** - The average number of tweets per day
- **average_originals** - The average number of originals per day
- **average_replies** - The average number of replies per day
- **average_retweets** - The average number of retweets per day
- **sixty_total_tweets** - The total number of tweets in the sixty days up to and including the last date
- **sixty_total_originals** - The total number of originals in the sixty days up to and including the last date
- **sixty_total_replies** - The total number of replies in the sixty days up to and including the last date
- **sixty_total_retweets** - The total number of retweets in the sixty days up to and including the last date
- **sixty_average_tweets** - The average number of tweets in the sixty days up to and including the last date
- **sixty_average_originals** - The average number of originals in the sixty days up to and including the last date
- **sixty_average_replies** - The average number of replies in the sixty days up to and including the last date
- **sixty_average_retweets** - The average number of retweets in the sixty days up to and including the last date
- **most_tweets_date** - The date with the most tweets
- **most_tweets_count** - The count of the most tweets
- **most_originals_date** - The date with the most originals
- **most_originals_count** - The count of the most originals
- **most_replies_date** - The date with the most replies
- **most_replies_count** - The count of the most replies
- **most_retweets_date** - The date with the most retweets
- **most_retweets_count** - The count of the most retweets
