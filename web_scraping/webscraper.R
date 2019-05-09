rm(list=ls())
library(rvest)

# this is an example that I've set up in 2017
# the website no longer exists, so the code in this file can't work anymore
# use this as an example of how you can set up a web scraper, but if you want to try it out yourselves, then choose a different website
# I have included one RData file in this folder that contains the data straped on 20170302

html_ratings <- read_html("http://www.kamergotchi.nl/totaal-ranglijst/")
html_dagtop50 <- read_html("http://www.kamergotchi.nl/ranglijst/")

date_of_ratings = date()
day_of_ratings = Sys.Date()
time_of_ratings = format(Sys.time(), "%H:%M:%S")

# indicate the position of the fields you are interested in 
html_position = html_nodes(html_ratings, "td:nth-child(1)")
position=as.numeric(html_text(html_position))

html_player = html_nodes(html_ratings, "td:nth-child(2) span")
player=html_text(html_player)

html_score = html_nodes(html_ratings, "td~ td+ td span")
score=html_text(html_score)

html_player_and_politician = html_nodes(html_ratings, "td:nth-child(2)")
player_politician_party = html_text(html_player_and_politician)
politician_party = substr(player_politician_party,nchar(player)+1,nchar(player_politician_party))

politician = vector(length = 50)
party      = vector(length = 50)
for(j in 1:50) {
  politician[j] = substr(politician_party[j], 1, gregexpr('\\(',politician_party[j])[[1]][1]-2)
  party[j]      = substr(politician_party[j], gregexpr('\\(',politician_party[j])[[1]][1]+1, nchar(politician_party[j])-1)
}

html_scoreanddays = html_nodes(html_ratings, "td:nth-child(3)")
scoreanddays=html_text(html_scoreanddays)
days=substr(scoreanddays,nchar(score)+1,nchar(scoreanddays))
days_numeric=substr(days,1,nchar(days)-nchar(" dagen in leven"))

ratings=data.frame(position = position,
                   player = player,
                   politician = politician,
                   party = party,
                   score = as.numeric(score),
                   days = as.numeric(days_numeric),
                   collected_on = date_of_ratings,
                   day = day_of_ratings,
                   hour = time_of_ratings)

html_position_top50 = html_nodes(html_dagtop50, "td:nth-child(1)")
position_top50=as.numeric(html_text(html_position_top50))

html_player_top50 = html_nodes(html_dagtop50, "td:nth-child(2) span")
player_top50=html_text(html_player_top50)

html_player_and_politician_top50 = html_nodes(html_dagtop50, "td:nth-child(2)")
player_and_politician_top50=html_text(html_player_and_politician_top50)
politician_party_top50=substr(player_and_politician_top50,nchar(player_top50)+1,nchar(player_and_politician_top50))

politician_top50 = vector(length = 50)
party_top50      = vector(length = 50)
for(j in 1:50) {
  politician_top50[j] = substr(politician_party_top50[j], 1, gregexpr('\\(',politician_party_top50[j])[[1]][1]-2)
  party_top50[j]      = substr(politician_party_top50[j], gregexpr('\\(',politician_party_top50[j])[[1]][1]+1, nchar(politician_party_top50[j])-1)
}

dagtop50=data.frame(position = position_top50,
                    player = player_top50,
                    politician = politician_top50,
                    party = party_top50,
                    collected_on = date_of_ratings,
                    day = day_of_ratings,
                    hour = time_of_ratings)

save(ratings, dagtop50, html_ratings, html_dagtop50, file=file.path("D:/Dropbox/phd/Research/Code/Project_Kamergotchi",paste("ratings_",format(Sys.time(), "%Y%m%d"),".RData",sep="")))

#### tweet
apikey <- "Gjhq78YpzUyPw4m68F5g8r9fv" #API Key
apisecret <- "0TShA6pdqO6QuEnhM3HDSznLX4q80JE4IbnlH8cJc2X65P63dE" #API Secret
token <- "710858241819975681-Es31InrgUVU5oORfUqXkiuHOsQJHmHD" #Access Token
tokensecret <- "la2hzLjwalVlUrl63OtH1MbzzFySMXo9ggGL5nVz42GHW" #Access token secret
  
library(twitteR)
setup_twitter_oauth(apikey, apisecret, token, tokensecret)

# now that scraping is done, tweet to let me know it worked out fine
tweet(paste(Sys.Date(), format(Sys.time(), "%H:%M:%S")))
