# Set global variables to be shared with other functions
if (getRversion() >= "2.15.1") utils::globalVariables(c("GAToken"))

# Environment for OAuth token
TokenEnv <- new.env(parent = emptyenv())

# Check koen exists
token_exists <- function(name) {
    exists(name, envir = TokenEnv)
}

# Set token to environment
set_token <- function(name, value) {
    assign(name, value, envir = TokenEnv)
    return(value)
}

# Get token from environment
get_token <- function(name) {
    get(name, envir = TokenEnv)
}

#' @title Authorize the RGA package to the user's Google Analytics account using OAuth2.0
#'
#' @description \code{authorize} function uses \code{\link[httr]{oauth2.0_token}} to obtain the OAuth tokens. Expired tokens will be refreshe automamaticly.
#'
#' @param client.id character. OAuth client ID. if client.id is missing, we'll look in the environment variable \code{RGA_CONSUMER_ID}.
#' @param client.secret character. OAuth client secret. if client.secret is missing, we'll look in the environment variable \code{RGA_CONSUMER_SECRET}.
#' @param cache logical or character. \code{TRUE} means to cache using the default cache file \code{.oauth-httr}, \code{FALSE} means not to cache. A string means to use the specified path as the cache file.
#'
#' @details
#'
#' This function requires client ID and client secret. In order to obtain these, you will have to register an application with the Google Analytics API. To find your project's client ID and client secret, do the following:
#'
#' \enumerate{
#'   \item Go to the \href{https://console.developers.google.com/}{Google Developers Console}.
#'   \item Select a project (create if needed).
#'   \item Select \emph{APIs & auth} in the sidebar on the left. Then in the list of APIs make sure that the status is \emph{ON} for the Analytics API.
#'   \item Select \emph{Credentials} in the sidebar on the left.
#'   \item To set up a service account select \emph{Create New Client ID}. Select \emph{Installed Application} and \emph{Others} options and then select \emph{Create Client ID}.
#' }
#'
#' You can return to the \href{https://console.developers.google.com/}{Google Developers Console} at any time to view the client ID and client secret on the \emph{Client ID for native application} section on \emph{Credentials} page.
#'
#' After calling this function first time, a web browser will be opened. First, log in with a Google Account, confirm the authorization to access the Google Analytics data. Note that the package requests access for read-only data.
#'
#' When the \code{authorize} function is used the \code{GAToken} variable is created in the separate \code{TokenEnv} environment which is not visible for user. So, there is no need to pass the token argument to any function which requires authorisation every time. Also there is a possibility to store token in separate variable and to pass it to the functions. It can be useful when you are working with several accounts at the same time.
#'
#' @return A \code{\link[httr]{Token2.0}} object containing all the data required for OAuth access.
#'
#' @references \href{https://console.developers.google.com/}{Google Developers Console}
#'
#' \href{http://en.wikipedia.org/wiki/Environment_variable}{Environment variable}
#'
#' @seealso
#' Other OAuth: \code{\link[httr]{oauth_app}} \code{\link[httr]{oauth2.0_token}} \code{\link[httr]{Token-class}}
#'
#' Setup environment variables: \code{\link{Startup}}
#'
#' @examples
#' \dontrun{
#' authorize(client.id = "myID", client.secret = "mySecret")
#' # if set RGA_CONSUMER_ID and RGA_CONSUMER_SECRET environment variables
#' authorize()
#' # assign token to variable
#' ga_token <- authorize(client.id = "myID", client.secret = "mySecret")
#' }
#'
#' @importFrom httr oauth_app oauth_endpoints oauth2.0_token
#' @import httpuv
#'
#' @export
#'
authorize <- function(client.id, client.secret, cache = TRUE) {
    client.id_env <- Sys.getenv("RGA_CONSUMER_ID")
    client.secret_env <- Sys.getenv("RGA_CONSUMER_SECRET")
    if (missing(client.id) || !nzchar(client.id)) {
        if (nzchar(client.id_env))
            client.id <- client.id_env
        else
            stop("Clinet ID not specified.")
    }
    if (missing(client.secret) || !nzchar(client.secret)) {
        if (nzchar(client.secret_env))
            client.secret <- client.secret_env
        else
            stop("Clinet secret not specified.")
    }
    rga_app <- oauth_app(appname = "rga", key = client.id, secret = client.secret)
    token <- oauth2.0_token(endpoint = oauth_endpoints("google"), app = rga_app, cache = cache,
                            scope = "https://www.googleapis.com/auth/analytics.readonly")
    set_token("GAToken", token)
    invisible(token)
}
