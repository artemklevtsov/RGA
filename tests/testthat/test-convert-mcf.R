context("Convert MCF Reporting API response")

mcf_data_pr <- structure(list(
    totalResults = 3L,
    containsSampledData = FALSE,
    columnHeaders = structure(list(
        name = c("mcf:medium", "mcf:totalConversions", "mcf:totalConversionValue"),
        columnType = c("DIMENSION", "METRIC", "METRIC"),
        dataType = c("STRING", "INTEGER", "CURRENCY")),
        .Names = c("name", "columnType", "dataType"),
        class = "data.frame",
        row.names = c(NA, 3L)),
    rows = list(
        structure(list(
            primitiveValue = c("(none)", "2759", "0.0")),
            .Names = "primitiveValue",
            class = "data.frame",
            row.names = c(NA, 3L)),
        structure(list(
            primitiveValue = c("organic", "4873", "0.0")),
            .Names = "primitiveValue",
            class = "data.frame",
            row.names = c(NA, 3L)),
        structure(list(
            primitiveValue = c("referral", "296", "0.0")),
            .Names = "primitiveValue",
            class = "data.frame",
            row.names = c(NA, 3L)))),
    .Names = c("totalResults", "containsSampledData", "columnHeaders", "rows"))


mcf_pr_df <- build_df(type = "mcf", mcf_data_pr)

test_that("class", {
    expect_is(mcf_pr_df, "data.frame")
})

test_that("dimensions", {
    expect_equal(ncol(mcf_pr_df), 3L)
    expect_equal(nrow(mcf_pr_df), 3L)
})

test_that("columns types", {
    expect_is(mcf_pr_df[, 1L], "character")
    expect_is(mcf_pr_df[, 2L], "integer")
    expect_is(mcf_pr_df[, 3L], "numeric")
})

mcf_cv_data <- structure(list(
    totalResults = 542L, containsSampledData = FALSE,
    columnHeaders = structure(list(
        name = c("mcf:mediumPath", "mcf:totalConversions", "mcf:totalConversionValue"),
        columnType = c("DIMENSION", "METRIC", "METRIC"), dataType = c("MCF_SEQUENCE", "INTEGER", "CURRENCY")),
        .Names = c("name", "columnType", "dataType"),
        class = "data.frame",
        row.names = c(NA, 3L)),
    rows = list(
        structure(list(
            conversionPathValue = list(
                structure(list(
                    nodeValue = "(none)"),
                    .Names = "nodeValue",
                    class = "data.frame",
                    row.names = 1L),
                NULL, NULL),
            primitiveValue = c(NA, "375", "0.0")),
            .Names = c("conversionPathValue", "primitiveValue"),
            class = "data.frame",
            row.names = c(NA, 3L)),
        structure(list(
            conversionPathValue = list(
                structure(list(
                    nodeValue = c("(none)", "(none)")),
                    .Names = "nodeValue",
                    class = "data.frame",
                    row.names = 1:2),
                NULL, NULL),
            primitiveValue = c(NA, "93", "0.0")),
            .Names = c("conversionPathValue", "primitiveValue"),
            class = "data.frame",
            row.names = c(NA, 3L)),
        structure(list(
            conversionPathValue = list(
                structure(list(
                    nodeValue = c("(none)", "(none)", "(none)")),
                    .Names = "nodeValue",
                    class = "data.frame",
                    row.names = c(NA, 3L)), NULL, NULL),
            primitiveValue = c(NA, "45", "0.0")),
            .Names = c("conversionPathValue", "primitiveValue"),
            class = "data.frame",
            row.names = c(NA, 3L)),
        structure(list(
            conversionPathValue = list(
                structure(list(
                    nodeValue = c("(none)", "(none)", "(none)", "(none)")),
                    .Names = "nodeValue",
                    class = "data.frame",
                    row.names = c(NA, 4L)),
                NULL, NULL),
            primitiveValue = c(NA, "36", "0.0")),
            .Names = c("conversionPathValue", "primitiveValue"),
            class = "data.frame",
            row.names = c(NA, 3L)),
        structure(list(
            conversionPathValue = list(
                structure(list(
                    nodeValue = c("(none)", "(none)", "(none)", "(none)", "(none)")),
                    .Names = "nodeValue",
                    class = "data.frame",
                    row.names = c(NA, 5L)),
                NULL, NULL),
            primitiveValue = c(NA, "25", "0.0")),
            .Names = c("conversionPathValue", "primitiveValue"),
            class = "data.frame",
            row.names = c(NA, 3L)))),
    .Names = c("totalResults", "containsSampledData", "columnHeaders", "rows"))


mcf_cv_df <- build_df(type = "mcf", mcf_cv_data)

test_that("class", {
    expect_is(mcf_cv_df, "data.frame")
})

test_that("dimensions", {
    expect_equal(ncol(mcf_cv_df), 3L)
    expect_equal(nrow(mcf_cv_df), 5L)
})

test_that("columns types", {
    expect_is(mcf_cv_df[, 1L], "character")
    expect_is(mcf_cv_df[, 2L], "integer")
    expect_is(mcf_cv_df[, 3L], "numeric")
})
