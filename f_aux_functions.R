f_test_API_standard_academic <- function(token_type) {
    if(token_type == "standard") {
        bearer_token <- Sys.getenv("BEARER_TOKEN")
    } else {
        if(token_type == "academic") {
            bearer_token <- Sys.getenv("BEARER_TOKEN_ACAD")
        } else {
            cat("You need to specify the type of token to test: standard or academic.")
        }
    }
    
    if(is.null(bearer_token)) {
        cat("The bearer token is empty. Fix this before you continue!\n")
    } else {
        cat("The bearer token has a value. Let's see if it's the correct value.\n")
        headers  <- c(Authorization = paste0("Bearer ", bearer_token))
        params   <- list(user.fields = "description")
        response <-	httr::GET(url = "https://api.twitter.com/2/users/by?usernames=Ana_Martinovici",
                              config = httr::add_headers(.headers = headers),
                              query = params)
        # for a complete list of HTTP status codes, 
        #		check: https://developer.twitter.com/ja/docs/basics/response-codes
        if(httr::status_code(response) == 200) {
            cat(paste("The HTTP status code is: ", status_code(response), sep = ""))
            cat("\n")
            cat("This means Success!")
        } else {
            cat("Oh, no! Something went wrong.\n")
            cat(paste("The HTTP status code is: ", status_code(response), "\n", sep = ""))
            cat("Check the list of HTTP status codes to understand what went wrong.\n")
        }
        
        # put the headers in a list so it doesn't show up on screen
        my_header <- list(headers = headers)
        return(my_header)
    }
}

f_get_geo_placeid <- function(input_list) {
    if(is.null(input_list[["geo"]])) {
        # you can change the label
        return("no_geo_info")
    } else {
        return(input_list[["geo"]][["place_id"]])	
    }
}

f_get_tweet_type <- function(input_list) {
    if(is.null(input_list[["referenced_tweets"]])) {
        # you can change the label for a tweet that is neither a quote nor a retweet
        return("original_tweet")
    } else {
        return(input_list[["referenced_tweets"]][[1]][["type"]])	
    }
}

f_get_ref_tweet_id <- function(input_list) {
    if(is.null(input_list[["referenced_tweets"]])) {
        # you can change the label for a tweet that is neither a quote nor a retweet
        return("original_tweet")
    } else {
        return(input_list[["referenced_tweets"]][[1]][["id"]])	
    }
}

f_get_retweet_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["retweet_count"]])	
    }
}

f_get_reply_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["reply_count"]])	
    }
}

f_get_like_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["like_count"]])	
    }
}

f_get_quote_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["quote_count"]])	
    }
}

f_get_followers_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["followers_count"]])	
    }
}

f_get_following_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["following_count"]])	
    }
}

f_get_tweet_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["tweet_count"]])	
    }
}

f_get_u_location <- function(input_list) {
    if(is.null(input_list[["location"]])) {
        # you can change the label 
        return("no_u_location")
    } else {
        return(input_list[["location"]])	
    }
}

f_get_listed_count <- function(input_list) {
    if(is.null(input_list[["public_metrics"]])) {
        # you can change the label 
        return("no_public_metrics")
    } else {
        return(input_list[["public_metrics"]][["listed_count"]])	
    }
}

# you should only collect the data you need
ALL_tweet_fields <- c("attachments",
                      "author_id",
                      "context_annotations",
                      "conversation_id",
                      "created_at",
                      "entities",
                      "geo",
                      "id",
                      "in_reply_to_user_id",
                      "lang",
                      "possibly_sensitive",
                      "public_metrics",
                      "referenced_tweets",
                      "reply_settings",
                      "source",
                      "text",
                      "withheld")

ALL_place_fields <- c("contained_within",
                      "country",
                      "country_code",
                      "full_name",
                      "geo",
                      "id",
                      "name",
                      "place_type")

ALL_user_fields <- c("created_at",
                     "description",
                     "id",
                     "location",
                     "name",
                     "pinned_tweet_id",
                     "profile_image_url",
                     "protected",
                     "public_metrics",
                     "url",
                     "username",
                     "verified",
                     "withheld")

ALL_expansions <- c("attachments.poll_ids",
                    "attachments.media_keys",
                    "author_id",
                    "entities.mentions.username",
                    "geo.place_id",
                    "in_reply_to_user_id",
                    "referenced_tweets.id",
                    "referenced_tweets.id.author_id")

EP_username_lookup <- "https://api.twitter.com/2/users/by?usernames="
EP_tweet_lookup    <- "https://api.twitter.com/2/tweets?ids="

EP_recent_search   <- "https://api.twitter.com/2/tweets/search/recent?query="
# max 100 tweets per request in reverse chronological order
# max 450 requests per 15 minutes
# this means you can get max 45 000 tweets in 15 minutes

EP_full_search     <- 'https://api.twitter.com/2/tweets/search/all?query='
