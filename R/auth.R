# The inner package environment
.RGAEnv <- new.env(parent = emptyenv())

# Check token exists
token_exists <- function(name) {
    exists(name, envir = .RGAEnv)
}

# Set token to environment
set_token <- function(name, value) {
    assign(name, value, envir = .RGAEnv)
    return(value)
}

# Get token from environment
get_token <- function(name) {
    stopifnot(token_exists(name))
    get(name, envir = .RGAEnv)
}

# Remove token from environment
remove_token <- function(name) {
    stopifnot(token_exists(names))
    cache_path <- get_token(name)$cache_path
    if (!is.null(cache_path) && file.exists(cache_path)) {
        message(sprintf("Removed old cache file: %s.", cache_path))
        file.remove(cache_path)
    }
    remove(list = name, envir = .RGAEnv)
}

# Validate token
validate_token <- function(x) {
    if (missing(x))
         stop("Authorization error. Access token not found.")
    if (!inherits(x, "Token2.0"))
        stop(sprintf("Token is not a Token2.0 object. Found: %s.", class(x)))
    if (!is.null(x$credentials$error)) {
        if (x$credentials$error == "invalid_request")
            stop("Authorization error. No access token obtained.")
        if (x$credentials$error == "invalid_client")
            stop("Authorization error. Please check client.id and client.secret.")
    }
    return(TRUE)
}

# Check environment variables exists
env_exists <- function(...) {
    dots <- list(...)
    res <- lapply(dots, Sys.getenv)
    vapply(res, nzchar, logical(1))
}

# Fix username without domain
fix_username <- function(x) {
    if (!grepl("@", x, fixed = TRUE))
        x <- paste0(x, "@gmail.com")
    return(x)
}

#' @title Authorize the RGA package to the user's Google Analytics account using OAuth2.0
#'
#' @description \code{authorize()} function uses \code{\link[httr]{oauth2.0_token}} to obtain the OAuth tokens. Expired tokens will be refreshed automamaticly. If you have no \code{client.id} and \code{client.secret} the package provides predefined values.
#'
#' @param username character. Google username email address hint. If not set you will need choose an account for the authorization.
#' @param client.id character. OAuth client ID. If you set the environment variable \env{RGA_CLIENT_ID} it is used.
#' @param client.secret character. OAuth client secret. If you set the environment variable \env{RGA_CLIENT_SECRET} it is used.
#' @param cache logical or character. \code{TRUE} means to cache using the default cache file \code{.oauth-httr}, \code{FALSE} means not to cache. A string means to use the specified path as the cache file. Otherwise will be used the \code{rga.cache} option value (\code{.ga-token.rds} by default). If \code{username} argument specified token will be cached in the \code{.username-token.rds} file.
#' @param new.auth logical. Set \code{TRUE} to reauthorization with the same or different Google Analytics account.
#'
#' @details
#'
#' After calling this function first time, a web browser will be opened. First, log in with a Google Account, confirm the authorization to access the Google Analytics data. Note that the package requests access for read-only data.
#'
#' When the \code{authorize()} function is used the \code{Token} variable is created in the separate \code{.RGAEnv} environment which is not visible for user. So, there is no need to pass the token argument to any function which requires authorization every time. Also there is a possibility to store token in separate variable and to pass it to the functions. It can be useful when you are working with several accounts at the same time.
#'
#' \code{username}, \code{client.id}, \code{client.secret} and \code{cache} params can be specified by an appropriate options (with \dQuote{rga} prefix).
#'
#' @section Use custom Client ID and Client secret:
#'
#' For some reasons you may need to use a custom client ID and client secret. In order to obtain these, you will have to register an application with the Google Analytics API. To find your project's client ID and client secret, do the following:
#'
#' \enumerate{
#'   \item Go to the \href{https://console.developers.google.com/}{Google Developers Console}.
#'   \item Select a project (create if needed).
#'   \item Select \emph{APIs & auth} in the sidebar on the left.
#'   \item In the list of APIs select \emph{Analytics API}. Then click \emph{Enable API}.
#'   \item Select \emph{Credentials} in the sidebar on the left.
#'   \item To set up a service account select \emph{Add credentials}. Select \emph{OAuth 2.0 client ID} and \emph{Other} options and then select \emph{Create}.
#' }
#'
#' You can return to the \href{https://console.developers.google.com/}{Google Developers Console} at any time to view the client ID and client secret on the \emph{Client ID for native application} section on \emph{Credentials} page.
#'
#' There 3 ways to use custom Client ID and Client secret:
#'
#' \enumerate{
#'   \item Pass the \code{client.id} and \code{client.secret} arguments directly in the \code{authorize()} function call
#'   \item Set the \env{RGA_CLIENT_ID} and \env{RGA_CLIENT_SECRET} environment variables
#'   \item Set the \code{rga.client.id} and \code{rga.client.secret} options
#' }
#'
#' @section Revoke access application:
#'
#' To revoke access the \pkg{RGA} package do the following:
#'
#' \enumerate{
#'   \item Go to the \href{https://security.google.com/settings/security/permissions}{Apps connected to your account} page
#'   \item Find \emph{RGA package} entry. Then click on it
#'   \item Click on the \emph{Revoke access} button in the sidebar on the right
#' }
#'
#' @return A \code{\link[httr]{Token2.0}} object containing all the data required for OAuth access.
#'
#' @references \href{https://console.developers.google.com/}{Google Developers Console}
#'
#' \href{http://en.wikipedia.org/wiki/Environment_variable}{Environment variable}
#'
#' @seealso
#'
#' Other OAuth: \code{\link[httr]{oauth_app}} \code{\link[httr]{oauth2.0_token}} \code{\link[httr]{Token-class}}
#'
#' To revoke all tokens: \code{\link[httr]{revoke_all}}
#'
#' Setup environment variables: \code{\link{Startup}}
#'
#' @examples
#' \dontrun{
#' authorize(client.id = "my_id", client.secret = "my_secret")
#' # if set RGA_CLIENT_ID and RGA_CLIENT_SECRET environment variables
#' authorize()
#' # assign token to variable
#' ga_token <- authorize(client.id = "my_id", client.secret = "my_secret")
#' }
#'
#' @export
#'
authorize <- function(username = getOption("rga.username"),
                      client.id = getOption("rga.client.id"),
                      client.secret = getOption("rga.client.secret"),
                      cache = getOption("rga.cache"),
                      new.auth = FALSE) {
    if (all(env_exists("RGA_CLIENT_ID", "RGA_CLIENT_SECRET"))) {
        message("Client ID and Client secret loaded from environment variables.")
        client.id <- Sys.getenv("RGA_CLIENT_ID")
        client.secret <- Sys.getenv("RGA_CLIENT_SECRET")
    }
    if (env_exists("RGA_USERNAME")) {
        message("Username loaded from environment variable.")
        username <- Sys.getenv("RGA_USERNAME")
    }
    app <- httr::oauth_app(appname = "rga", key = client.id, secret = client.secret)
    endpoint <- httr::oauth_endpoints("google")
    if (!is.null(username)) {
        stopifnot(is.character(username))
        stopifnot(length(username) == 1)
        username <- fix_username(username)
        endpoint$authorize <- paste0(endpoint$authorize, "?login_hint=", username)
        if (is.character(cache))
            cache <- paste0(".", username, "-token.rds")
    }
    if (new.auth)
        remove_token("Token")
    if (is.character(cache) && nzchar(cache))
        message(sprintf("Access token will be stored in the %s file.", dQuote(cache)))
    token <- httr::oauth2.0_token(endpoint = endpoint, app = app, cache = cache,
                            scope = "https://www.googleapis.com/auth/analytics.readonly")
    if (validate_token(token))
        set_token("Token", token)
    return(invisible(token))
}
