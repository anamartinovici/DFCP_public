# make sure to install this package
library(httr)

# Replace the bearer token below with the bearer_token for your own app
bearer_token <- "thisisnotarealtoken"

headers = c(
    `Authorization` = sprintf('Bearer %s', bearer_token)
)

params = list(
    `query` = 'from:Ana_Martinovici',
    `max_results` = '10',
    `tweet.fields` = 'created_at,lang,context_annotations'
)

response <- httr::GET(url = 'https://api.twitter.com/2/tweets/search/recent', httr::add_headers(.headers=headers), query = params)

fas_body <-
    content(
        response,
        as = 'parsed',
        type = 'application/json',
        simplifyDataFrame = TRUE
    )

View(fas_body$data)
