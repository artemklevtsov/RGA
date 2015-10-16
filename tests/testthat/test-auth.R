context("Authorization")

check_token <- function() {
    if (!file.exists(".ga-token.rds"))
        skip("Access token not available")
    suppressMessages(authorize(cache = ".ga-token.rds"))
}

test_that("Test access token exists", {
    check_token()
    expect_true(token_exists("Token"))
    expect_true(validate_token(get_token("Token")))
})

test_that("Test API request with access token", {
    check_token()
    url <- "https://www.googleapis.com/analytics/v3/management/accounts?max-results=1"
    req <- httr::GET(url, httr::config(token = get_token("Token")))
    expect_equal(httr::status_code(req), 200L)
})
