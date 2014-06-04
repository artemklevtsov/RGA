# Get OAuth 2.0 token
get_token <- function(client.id, client.secret) {
    client.id_env <- Sys.getenv(x = "RGA_CONSUMER_ID")
    client.secret_env <- Sys.getenv(x = "RGA_CONSUMER_SECRET")
    if (missing(client.id) || client.id = "" && client.id_env == "") {
        stop("Clinet ID not specified.")
    }
    if (missing(client.secret) || client.secret = "" && client.secret_env == "") {
        stop("Clinet secret not specified.")
    }
    if (missing(client.id) || client.id = "" && client.id_env != "") {
        client.id <- client.id_env
    }
    if (missing(client.secret) || client.secret = "" && client.secret_env != "") {
        client.secret <- client.secret_env
    }
    rga_app <- oauth_app(appname = "rga", key = client.id, secret = client.secret)
    token <- oauth2.0_token(endpoint = oauth_endpoints(name = "google"), app = rga_app,
                            scope = "https://www.googleapis.com/auth/analytics.readonly")
    return(token)
}
