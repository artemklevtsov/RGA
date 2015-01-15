context("Metadata Reporting API response")

data <- list_metadata(report.type = "ga")

test_that("class", {
    expect_is(data, "data.frame")
})

test_that("dimensions", {
    expect_equal(ncol(data), 14L)
})

test_that("names", {
    expect_equal(names(data), c("id", "type", "data.type", "group", "status", "ui.name", "description", "allowed.in.segments", "replaced.by", "calculation", "min.template.index", "max.template.index", "premium.min.template.index", "premium.max.template.index"))
})
