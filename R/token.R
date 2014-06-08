#' @title Generate an oauth2.0 token
#'
#' @description
#' \code{get_token} is wrapper for \code{link[httr]{oauth2.0_token} function}.
#'
#' @param client.id OAuth client ID.
#' @param client.secret OAuth client secret.
#' @param ... arguments to be passed to \code{oauth2.0_token}.
#'
#' @details
#' Client ID and client secret also can be set with \code{RGA_CONSUMER_ID} and \code{RGA_CONSUMER_SECRET} environment variables.
#'
#' @return A Token2.0 reference class (RC) object.
#'
#' @references
#' Google Developers Console: \url{https://console.developers.google.com/}
#'
#' Environment variable: \url{http://en.wikipedia.org/wiki/Environment_variable}
#'
#' @seealso
#' Other OAuth: \code{\link[httr]{oauth_app}} \code{\link[httr]{oauth2.0_token}} \code{\link[httr]{Token-class}}
#'
#' Setup environment variables: \code{\link{Startup}}
#'
#' @examples
#' \dontrun{
#' ga_token <- get_token(client.id = "myID", client.secret = "mySecret")
#' # if set RGA_CONSUMER_ID and RGA_CONSUMER_SECRET environment variables
#' ga_token <- get_token()
#' }
#'
#' @import httr
#'
#' @export
#'
get_token <- function(client.id, client.secret, ...) {
    client.id_env <- Sys.getenv(x = "RGA_CONSUMER_ID")
    client.secret_env <- Sys.getenv(x = "RGA_CONSUMER_SECRET")
    if (missing(client.id) || client.id == "") {
        if (client.id_env == "")
            stop("Clinet ID not specified.")
        else
            client.id <- client.id_env
    }
    if (missing(client.secret) || client.secret == "") {
        if (client.secret_env == "")
            stop("Clinet secret not specified.")
        else
            client.secret <- client.secret_env
    }
    rga_app <- oauth_app(appname = "rga", key = client.id, secret = client.secret)
    token <- oauth2.0_token(endpoint = oauth_endpoints(name = "google"), app = rga_app,
                            scope = "https://www.googleapis.com/auth/analytics.readonly", ...)
    return(token)
}
