f_test_token_API <- function() {
    if(is.null(Sys.getenv("BEARER_TOKEN"))) {
        cat("The bearer token is empty. Fix this before you continue!\n")
        cat("Check the step-by-step instructions on how to save the bearer token as an environment variable.\n")
    } else {
        cat("The bearer token has a value. Let's see if it's the correct value.\n")
        headers <- c(Authorization = paste0('Bearer ', Sys.getenv("BEARER_TOKEN")))
        
        params <- list(user.fields = 'description')
        handle <- 'Ana_Martinovici'
        url_handle <- paste0('https://api.twitter.com/2/users/by?usernames=', handle)
        response <-	httr::GET(url = url_handle,
                              config = httr::add_headers(.headers = headers),
                              query = params)
        
        # for a complete list of HTTP status codes, 
        #		check: https://developer.twitter.com/ja/docs/basics/response-codes
        if(httr::status_code(response) == 200) {
            cat(paste0("The HTTP status code is: ", httr::status_code(response), "\n"))
            cat("This means Success!\n")
        } else {
            cat("Oh, no! Something went wrong.\n")
            cat(paste("The HTTP status code is: ", httr::status_code(response), "\n", sep = ""))
            cat("Check the list of HTTP status codes to understand what went wrong.\n")
        }
        
        # put the headers in a list so it doesn't show up on screen
        my_header <- list(headers = headers)
        return(my_header)
    }
}