# there's no need for rm(list=ls()) at the start of the file
# to restart the R Session on Windows, use CTRL + SHIFT + F10

library("httr")
library("tidyverse")

source("f_aux_functions.R")
my_header <- f_test_API_standard_academic(token_type = "academic")

# this is a Tweet I (Ana_Martinovici) wrote
target_tweet_id  <- "1393188665002708999"
req_tweet_fields <- stringr::str_c(ALL_tweet_fields, collapse = ",")
req_place_fields <- stringr::str_c(ALL_place_fields, collapse = ",")
req_expansions   <- stringr::str_c(ALL_expansions, collapse = ",")
req_user_fields  <- stringr::str_c(ALL_user_fields, collapse = ",")

params <- list(ids = target_tweet_id,
               tweet.fields = req_tweet_fields,
               expansions = req_expansions,
               place.fields = req_place_fields,
               user.fields = req_user_fields)

response <- httr::GET(url = EP_tweet_lookup,
                      config = httr::add_headers(.headers = my_header[["headers"]]),
                      query = params)
httr::status_code(response)
obj <- httr::content(response)

obj[["data"]][[1]][["conversation_id"]]
obj[["data"]][[1]][["id"]]

conversation_id <- obj[["data"]][[1]][["conversation_id"]]
params <- list(query = paste0("conversation_id:", conversation_id),
               tweet.fields = req_tweet_fields,
               expansions = req_expansions,
               place.fields = req_place_fields,
               user.fields = req_user_fields)
response <- httr::GET(url = EP_recent_search,
                      config = httr::add_headers(.headers = my_header[["headers"]]),
                      query = params)
httr::status_code(response)
obj_conversation <- httr::content(response)

# note that when I use the recent search I don't get the replies 
#       because they are older than 7 days
# I need to use the full archive search to get them, but that requires an academic account
response <- httr::GET(url = EP_full_search,
                      config = httr::add_headers(.headers = my_header[["headers"]]),
                      query = params)
httr::status_code(response)
obj_conversation <- httr::content(response)
