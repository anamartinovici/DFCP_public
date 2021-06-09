# there's no need for rm(list=ls()) at the start of the file
# to restart the R Session on Windows, use CTRL + SHIFT + F10

library("httr")
library("tidyverse")

source("f_aux_functions.R")
my_header <- f_test_API_standard_academic(token_type = "standard")

target_username  <- "Ana_Martinovici,bayescalling"
req_expansions   <- "pinned_tweet_id"
req_user_fields  <- stringr::str_c(ALL_user_fields, collapse = ",")
req_tweet_fields <- stringr::str_c(ALL_tweet_fields, collapse = ",")

params <- list(usernames = target_username,
               expansions = req_expansions,
               tweet.fields = req_tweet_fields,
               user.fields = req_user_fields)

response <-	httr::GET(url = EP_username_lookup,
                      config = httr::add_headers(.headers = my_header[["headers"]]),
                      query = params)
httr::status_code(response)
obj <- httr::content(response)

