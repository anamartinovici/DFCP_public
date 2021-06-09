# there's no need for rm(list=ls()) at the start of the file
# to restart the R Session on Windows, use CTRL + SHIFT + F10

################################################
################################################
#
# test if you can connect to the API
#
################################################
################################################

# you need httr to GET data from the API
# note that httr can be used also with other APIs, 
#		it this is not specific to the Twitter API
library("httr")
# tictoc provides functions for timing
library("tictoc")
library("tidyverse")
# add more packages ONLY if you need to use them

# f_aux_functions.R contains a function that you can use to test the token
source("f_aux_functions.R")
my_header <- f_test_API_standard_academic(token_type = "standard")


################################################
################################################
#
# Does the bearer token allow you to collect data?
# if "Yes" -> continue
# else -> fix the error(s)
#
################################################
################################################

################################################
# Step 1: collect the user_id for this handle
################################################

target_username  <- "Ana_Martinovici"
params <- list(usernames = target_username)
response <-	httr::GET(url = EP_username_lookup,
                      config = httr::add_headers(.headers = my_header[["headers"]]),
                      query = params)
httr::status_code(response)
obj <- httr::content(response)
# data.id is the user_id I need
user_id <- obj[["data"]][[1]][["id"]]

################################################
# Step 2: get tweets for this user_id
################################################

url_handle <- paste0('https://api.twitter.com/2/users/', user_id, "/tweets")
# by default, the number of tweets retrieved per request is 10
# you can ask for more tweets (check the documentation for exact info)
params <- list(max_results = "100")
response <-	httr::GET(url = url_handle,
                      config = httr::add_headers(.headers = my_header[["headers"]]),
                      query = params)
httr::status_code(response)

################################################
# Step 3: get the remaining tweets for this user_id
################################################

# create an object where you store all responses
all_response_objects <- NULL
# so far, I've only requested data from the API once
request_number <- 1
# add the response I got from the API
all_response_objects[[request_number]] <- response
# add a name to this list element to know it is the response for the 
#		first iteration / first request
names(all_response_objects)[request_number] <- paste0("request_", request_number)

# as long as there are more tweets to collect, meta.next_token has a value
# otherwise, if meta.next_token is null, this means you've collected all
# tweets from this user
obj <- httr::content(response)
obj[["meta"]][["next_token"]]

Sys.sleep("2")
# now, use a loop to get the remaining number of requests
# as long as there are more tweets to collect, meta.next_token has a value
# otherwise, if meta.next_token is null, this means you've collected all tweets
#     that meet the query criteria
while(!is.null(obj[["meta"]][["next_token"]])) {
    # use tic toc functions to see how much time it takes per request
    tic("duration for request number: ")
    
    # keep track of the current request number
    request_number <- request_number + 1
    
    # this is where I left
    params[["pagination_token"]] <- obj[["meta"]][["next_token"]]
    response <-	httr::GET(url = url_handle,
                          config = httr::add_headers(.headers = my_header[["headers"]]),
                          query = params)
    httr::status_code(response)
    obj <- httr::content(response)
    
    # you can (and should) print some messages so you know 
    #		how many requests you've already placed
    #		and if these requests were successful
    cat(paste0("Request number: ", request_number, 
               " has HTTP status: ", httr::status_code(response), "\n"))
    # you could also add a check on the http status code in the while loop
    
    # add the current response to all_response_objects
    all_response_objects[[request_number]] <- response
    names(all_response_objects)[request_number] <- paste0("request_", request_number)
    
    Sys.sleep("2")
    
    # this stops the "stopwatch" and prints the time it took to execute the 
    #       lines of code between tic and toc
    toc()
}
