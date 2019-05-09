rm(list=ls())

# there are 2 packages that can be used to access Twitter data
library(twitteR)
library(rtweet)

# you need to set up your own app and keys
# these keys should no longer work and are left here just as an example
api_key <- "4o0TVozr4Zv9FGTm3GBS05UHX" #in the quotes, put your API key 
api_secret <- "IYU2Mvz5qk3l2a0EShIjSFkN8xq7cTxUuAxqL4RMMMv6kSgu21" #in the quotes, put your API secret token 
token <- "3695770529-2iI42ynXl11nsSWuPMK1uiHpoFN6cf1wxbTkbmk" #in the quotes, put your token 
token_secret <- "zPgmnwsl0p1DaIl7Olo4lDkBcLscNyvBU1Ukd7GD2H2Rx" #in the quotes, put your token secret

# this sets up twitter authentification using the twitteR package function
setup_twitter_oauth(api_key, api_secret, token, token_secret)

# this sets up twitter authentification using the rtweet package function
token <- create_token(app = "dfcp", 
                      consumer_key = api_key,
                      consumer_secret = api_secret,
                      access_token = token,
                      access_secret = token_secret)
identical(token, get_token())


# start with a small test to make sure everything works fine
# this should use a search string that is very likely to return results
# searchTwitter is part of the twitteR package
test <- searchTwitter("pizza", n = 100, lang = "en")
# transform to data frame
test_tweets <- twListToDF(test)

# test also the function provided by rtweet
test <- search_tweets("pizza", n = 100, lang = "en")
# remove the test objects if all went fine
remove(test, test_tweets)

# how many tweets do you want to extract?
ntweets_to_extract <- 18000

# any restrictions for dates or location? Keep in mind that the search API index includes only the past 6-9 days
date_since <- "2019-04-27"
date_until <- "2019-04-28"

# Rdam coordinates
# 51.9244° N, 4.4777° E
rdam_geocode <- '51.9244,4.4777,10km'

# this returns 0 results because the time interval is already too far back in time
tweets <- searchTwitter("#kingsday", n = ntweets_to_extract, lang = "en", since = date_since, until = date_until, geocode = rdam_geocode)

# looking into tweets about Ajax
# search_tweets already arranges data in a data.frame format
rt_ajax <- search_tweets("#AJAX", n = ntweets_to_extract, include_rts = TRUE)

# you can now check summarize the information in the tweets
# for example, by looking into the frequency of tweets with "#Ajax" over 3-hour intervals
library(ggplot2)
ts_plot(rt_ajax, "3 hours") +
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #AJAX Twitter statuses",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )


# the limit is set at 18000 tweets per 15 minutes, but if you need more than that, you can use "retryonratelimit = TRUE"
rt <- search_tweets("#Ajax", n = 250000, retryonratelimit = TRUE)
