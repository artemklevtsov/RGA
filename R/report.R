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
        profile <- get_profile(account.id = data_$profileInfo$accountId,
                               webproperty.id = data_$profileInfo$webPropertyId,
                               profile.id = data_$profileInfo$profileId, token = token)
        timezone <- profile$timezone
        if (!is.null(res$date.hour))
            res$date.hour <- as.POSIXct(strptime(res$date.hour, format = "%Y%m%d%H", tz = timezone))
        if (!is.null(res[["date"]]))
            res[["date"]] <- as.POSIXct(strptime(res[["date"]], "%Y%m%d", tz = timezone))
        if (!is.null(res$conversion.date))
            res$conversion.date <- as.POSIXct(strptime(res$conversion.date, "%Y%m%d", tz = timezone))
    }
    names(data_$profileInfo) <-  to_separated(names(data_$profileInfo), sep = ".")
    names(data_$query) <-  to_separated(names(data_$query), sep = ".")
    attr(res, "profile.info") <- data_$profileInfo
    attr(res, "query") <- fix_query(data_$query)
    attr(res, "sampled") <- data_$containsSampledData
    if (!is.null(data_$containsSampledData) && isTRUE(data_$containsSampledData)) {
        attr(res, "sample.size") <- as.numeric(data_$sampleSize)
        attr(res, "sample.space") <- as.numeric(data_$sampleSpace)
        sample_perc <- as.numeric(data_$sampleSize) / as.numeric(data_$sampleSpace) * 100
        warning(sprintf("Data contains sampled data. Used %d sessions (%1.0f%% of sessions). Try to use the %s param to avoid sampling.", as.numeric(data_$sampleSize), sample_perc, dQuote("fetch.by")), call. = FALSE)
    }
    return(res)
}
