# Get the Anaytics reporting data
#' @include query.R
#' @include get-data.R
#' @include profiles.R
get_report <- function(path, query, token) {
    data_ <- get_data(path, query, token)
    if (is.null(data_)) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    res <- data_$rows
    # Convert to POSIXct with timezone defined in the GA profile
    if (any(grepl("date", names(res), fixed = TRUE))) {
        timezone <- get_profile(data_$profile.info$account.id, data_$profile.info$webproperty.id, data_$profile.info$profile.id, token)$timezone
        if (!is.null(res$date.hour))
            res$date.hour <- as.POSIXct(strptime(res$date.hour, "%Y%m%d%H", tz = timezone))
        if (!is.null(res[["date"]]))
            res[["date"]] <- as.POSIXct(strptime(res[["date"]], "%Y%m%d", tz = timezone))
        if (!is.null(res$conversion.date))
            res$conversion.date <- as.POSIXct(strptime(res$conversion.date, "%Y%m%d", tz = timezone))
    }
    attr(res, "profile.info") <- data_$profile.info
    attr(res, "query") <- fix_query(data_$query)
    attr(res, "sampled") <- data_$contains.sampled.data
    if (!is.null(data_$contains.sampled.data) && isTRUE(data_$contains.sampled.data)) {
        attr(res, "sample.size") <- data_$sample.size
        attr(res, "sample.space") <- data_$sample.space
        sample_perc <- data_$sample.size / data_$sample.space * 100
        warning(sprintf("Data contains sampled data. Used %d sessions (%1.0f%% of sessions). Try to use the 'fetch.by' param to avoid sampling.", data_$sample.size, sample_perc), call. = FALSE)
    }
    return(res)
}
