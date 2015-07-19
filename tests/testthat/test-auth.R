context("Authorization")

library(httr)

check_token <- function() {
    if (!file.exists(".ga-token.rds"))
        skip("Access token not available")
    suppressMessages(authorize(cache = ".ga-token.rds"))
}

test_that("Test access token exists", {
    check_token()
    expect_true(token_exists(getOption("rga.token")))
    expect_is(get_token(getOption("rga.token")), "Token2.0")
})

test_that("Test API request with access token", {
    check_token()
    url <- "https://www.googleapis.com/analytics/v3/management/accounts/~all/webproperties/~all/profiles?max-results=1"
    req <- GET(url, config(token = get_token(getOption("rga.token"))))
    expect_equal(status_code(req), 200)
})
