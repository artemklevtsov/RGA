context("Metadata Reporting API response")

ga_data <- suppressMessages(list_dimsmets(report.type = "ga"))

test_that("Result class", {
    expect_is(ga_data, "data.frame")
})

test_that("Data frame dimensions", {
    expect_equal(ncol(ga_data), 14L)
})

test_that("Columns names", {
    expect_equal(names(ga_data), c("id", "type", "data.type", "group", "status", "ui.name", "description", "allowed.in.segments", "replaced.by", "calculation", "min.template.index", "max.template.index", "premium.min.template.index", "premium.max.template.index"))
})
