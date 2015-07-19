context("API request URL")

path <- "accounts"
query <- list(start.index = 1L, max.results = 5L, fields = "items(id,name,permissions/effective,created,updated)")
url <- get_url(type = "mgmt", path = path, query = query)

test_that("URL class", {
    expect_is(url, "character")
})

test_that("URL length", {
    expect_equal(length(url), 1L)
})

test_that("URL match", {
    expect_match(url, "management")
    expect_match(url, "accounts")
    expect_match(url, "start-index")
    expect_match(url, "max-results")
    expect_match(url, "fields")
})
