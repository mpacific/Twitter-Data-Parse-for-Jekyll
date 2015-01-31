module TwitterDataParse
	# Parse the CSV into a template that the page can use
	# Input = Twitter archive CSV, as parsed by Jekyll
	# Returns tweet counts broken down by day
	def twitter_parse(input)
		if input.instance_of? Array
			tweet_hash = Hash.new
			tweet_array = Array.new

			# Loop through the tweets
			for tweet in input
				tweet_date_obj = DateTime.parse(tweet['timestamp'])
				tweet_date = tweet_date_obj.new_offset(DateTime.now.offset).strftime('%F')

				# Set up hash if this is the first instance of the date
				if tweet_hash.has_key?(tweet_date) == false
					tweet_hash[tweet_date] = {
						'date' => tweet_date,
						'tweets' => 0,
						'originals' => 0,
						'replies' => 0,
						'retweets' => 0
					}
				end

				# Totals
				tweet_hash[tweet_date]['tweets'] += 1

				# Replies
				if !tweet['in_reply_to_status_id'].empty?
					tweet_hash[tweet_date]['replies'] += 1
				# Retweets
				elsif !tweet['retweeted_status_id'].empty?
					tweet_hash[tweet_date]['retweets'] += 1
				# Original tweets
				else
					tweet_hash[tweet_date]['originals'] += 1
				end
			end

			# Convert to array
			tweet_hash.sort.map do |tweet_key, tweet|
				tweet_array.push(tweet)
			end

			# Return!
			tweet_array
		else
			# Error
			'Twitter parse input error'
		end
	end

	# Compile various tweet stats
	# Input = Tweet counts, as compiled by twitter_parse()
	# Returns tweet stats (totals, averages, 60-day averages, superlatives)
	def twitter_stats(input)
		if input.instance_of? Array
			# Get current date and date 60 days before most recent tweet
			first_date = Date.parse(input.first['date'])
			last_date = Date.parse(input.last['date'])
			sixty_date = last_date - 60

			# Set up hash
			twitter_stats = {
				'total_days' => ((last_date - first_date) + 1).to_i, # Adding one since we're counting the last day as well
				'total_tweets' => 0,
				'total_originals' => 0,
				'total_replies' => 0,
				'total_retweets' => 0,
				'average_tweets' => 0,
				'average_originals' => 0,
				'average_replies' => 0,
				'average_retweets' => 0,
				'sixty_total_tweets' => 0,
				'sixty_total_originals' => 0,
				'sixty_total_replies' => 0,
				'sixty_total_retweets' => 0,
				'sixty_average_tweets' => 0,
				'sixty_average_originals' => 0,
				'sixty_average_replies' => 0,
				'sixty_average_retweets' => 0,
				'most_tweets_date' => '',
				'most_tweets_count' => 0,
				'most_originals_date' => '',
				'most_originals_count' => 0,
				'most_replies_date' => '',
				'most_replies_count' => 0,
				'most_retweets_date' => '',
				'most_retweets_count' => 0
			}

			# Loop through prepared tweets from twitter_parse()
			for tweet in input
				# Totals
				twitter_stats['total_tweets'] += tweet['tweets']
				twitter_stats['total_originals'] += tweet['originals']
				twitter_stats['total_replies'] += tweet['replies']
				twitter_stats['total_retweets'] += tweet['retweets']

				# Sixty day totals + averages
				tweet_date = Date.parse(tweet['date'])
				if tweet_date > sixty_date
					twitter_stats['sixty_total_tweets'] += tweet['tweets']
					twitter_stats['sixty_total_originals'] += tweet['originals']
					twitter_stats['sixty_total_replies'] += tweet['replies']
					twitter_stats['sixty_total_retweets'] += tweet['retweets']
				end

				# Superlatives
				if tweet['tweets'] > twitter_stats['most_tweets_count']
					twitter_stats['most_tweets_date'] = tweet['date']
					twitter_stats['most_tweets_count'] = tweet['tweets']
				end
				if tweet['originals'] > twitter_stats['most_originals_count']
					twitter_stats['most_originals_date'] = tweet['date']
					twitter_stats['most_originals_count'] = tweet['originals']
				end
				if tweet['replies'] > twitter_stats['most_replies_count']
					twitter_stats['most_replies_date'] = tweet['date']
					twitter_stats['most_replies_count'] = tweet['replies']
				end
				if tweet['retweets'] > twitter_stats['most_retweets_count']
					twitter_stats['most_retweets_date'] = tweet['date']
					twitter_stats['most_retweets_count'] = tweet['retweets']
				end
			end

			# Averages
			twitter_stats['average_tweets'] = (twitter_stats['total_tweets'] / twitter_stats['total_days'])
			twitter_stats['average_originals'] = (twitter_stats['total_originals'] / twitter_stats['total_days'])
			twitter_stats['average_replies'] = (twitter_stats['total_replies'] / twitter_stats['total_days'])
			twitter_stats['average_retweets'] = (twitter_stats['total_retweets'] / twitter_stats['total_days'])
			twitter_stats['sixty_average_tweets'] = (twitter_stats['sixty_total_tweets'] / 60)
			twitter_stats['sixty_average_originals'] = (twitter_stats['sixty_total_originals'] / 60)
			twitter_stats['sixty_average_replies'] = (twitter_stats['sixty_total_replies'] / 60)
			twitter_stats['sixty_average_retweets'] = (twitter_stats['sixty_total_retweets'] / 60)

			# Return!
			twitter_stats
		else
			# Error
			'Twitter stats input error'
		end
	end
end

# Register the filters
Liquid::Template.register_filter(TwitterDataParse)