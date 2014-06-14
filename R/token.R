#' @title Generate an oauth2.0 token
#'
#' @description
#' \code{get_token} is wrapper for \code{link[httr]{oauth2.0_token} function}.
#'
#' @param client.id OAuth client ID. if client.id is missing, we'll look in the environment variable RGA_CONSUMER_ID.
#' @param client.secret OAuth client secret. if client.secret is missing, we'll look in the environment variable RGA_CONSUMER_SECRET.
#' @param cache A logical value or a string. TRUE means to cache using the default cache file \code{.oauth-httr}, FALSE means don't cache. A string mean use the specified path as the cache file.
#'
#' @section Getting an OAuth Console Key and Secret:
#'
#' To find your project's client ID and client secret, do the following:
#'
#' \enumerate{
#'     \item Go to the \href{https://console.developers.google.com/}{Google Developers Console}.
#'     \item Select a project (create if needed).
#'     \item In the sidebar on the left, select \emph{APIs & auth}. In the list of \emph{APIs}, make sure the status is \emph{ON} for the \emph{Analytics API}.
#'     \item In the sidebar on the left, select \emph{Credentials}.
#'     \item To set up a service account, select \emph{Create New Client ID}. Select \emph{Installed Application} and \emph{Others} options and then select \emph{Create Client ID}.
#' }
#'
#' You can return to the \href{https://console.developers.google.com/}{Google Developers Console} at any time to view the client ID and client secret on the \emph{Client ID for native application} section on \emph{Credentials} page.
#'
#' @return A \code{\link[httr]{Token2.0}} reference class (RC) object.
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
get_token <- function(client.id, client.secret, cache = TRUE) {
    client.id_env <- Sys.getenv(x = "RGA_CONSUMER_ID")
    client.secret_env <- Sys.getenv(x = "RGA_CONSUMER_SECRET")
    if (missing(client.id) || !nzchar(client.id)) {
        if (!nzchar(client.id_env))
            stop("Clinet ID not specified.")
        else
            client.id <- client.id_env
    }
    if (missing(client.secret) || !nzchar(client.secret)) {
        if (!nzchar(client.secret_env))
            stop("Clinet secret not specified.")
        else
            client.secret <- client.secret_env
    }
    rga_app <- oauth_app(appname = "rga", key = client.id, secret = client.secret)
    token <- oauth2.0_token(endpoint = oauth_endpoints(name = "google"), app = rga_app, cache = cache,
                            scope = "https://www.googleapis.com/auth/analytics.readonly")
    return(token)
}
