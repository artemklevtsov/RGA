# Get the Anaytics reporting data
#' @include query.R
#' @include get-data.R
#' @include profiles.R
get_report <- function(path, query, token) {
    json_content <- get_data(path, query, token)
    if (is.null(json_content$rows) || length(json_content$rows) == 0) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    res <- json_content$rows
    # Convert dates to POSIXct with timezone defined in the GA profile
    if (any(grepl("date", names(res), fixed = TRUE))) {
        timezone <- get_profile(json_content$profile.info$account.id,
                                json_content$profile.info$webproperty.id,
                                json_content$profile.info$profile.id, token)$timezone
        if (!is.null(res$date.hour))
            res$date.hour <- lubridate::ymd_h(res$date.hour, tz = timezone)
        if (!is.null(res[["date"]]))
            res[["date"]] <- lubridate::ymd(res[["date"]], tz = timezone)
        if (!is.null(res$conversion.date))
            res$conversion.date <- lubridate::ymd(res$conversion.date, tz = timezone)
    }
    attr(res, "profile.info") <- json_content$profile.info
    attr(res, "query") <- fix_query(json_content$query)
    attr(res, "sampled") <- json_content$contains.sampled.data
    if (!is.null(json_content$contains.sampled.data) && isTRUE(json_content$contains.sampled.data)) {
        attr(res, "sample.size") <- json_content$sample.size
        attr(res, "sample.space") <- json_content$sample.space
        sample_perc <- json_content$sample.size / json_content$sample.space * 100
        warning(sprintf("Data contains sampled data. Used %d sessions (%1.0f%% of sessions). Try to use the 'fetch.by' param to avoid sampling.", json_content$sample.size, sample_perc), call. = FALSE)
    }
    return(res)
}
