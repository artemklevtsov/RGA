context("API request URL")

url <- get_url(type = "mgmt", path = "accounts")

test_that("URL class", {
    expect_is(url, "character")
})

test_that("URL length", {
    expect_equal(length(url), 1L)
})

test_that("URL match", {
    expect_match(url, "management")
    expect_match(url, "accounts")
})
