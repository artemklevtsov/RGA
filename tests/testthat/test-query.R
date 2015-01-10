context("Report query")

test_that("errors", {
    expect_error(set_query(NULL))
    expect_error(set_query(profile.id = ""))
    expect_error(et_query(profile.id = NA))
})

test_that("dates", {
    query <- set_query(profile.id = 0, end.date = Sys.Date())
    expect_equal(query$`end-date`, as.character(Sys.Date()))
})

test_that("spaces", {
    query <- set_query(profile.id = 0, filters = "ga:users > 1000")
    expect_false(grepl(query$filters, " "))
})

test_that("collapse", {
    query <- set_query(profile.id = 0, metrics = c("ga:users", "ga:sessions"), dimensions = c("ga:date", "ga:hour"))
    expect_equal(length(query$metrics), 1L)
    expect_equal(length(query$dimensions), 1L)
})
