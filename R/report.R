# Get the Anaytics reporting data
#'
#' @include query.R
#' @include get-data.R
#' @include profiles.R
#'
get_report <- function(path, query, token) {
    data_json <- get_data(path, query, token)
    if (is.null(data_json)) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    data_df <- data_json$rows
    # Convert to POSIXct with timezone defined in the GA profile
    if (any(grepl("date", names(data_df), fixed = TRUE))) {
        profile <- get_profile(account.id = data_json$profileInfo$accountId,
                               webproperty.id = data_json$profileInfo$webPropertyId,
                               profile.id = data_json$profileInfo$profileId, token = token)
        timezone <- profile$timezone
        if (!is.null(data_df$date.hour))
            data_df$date.hour <- as.POSIXct(strptime(data_df$date.hour, format = "%Y%m%d%H", tz = timezone))
        if (!is.null(data_df[["date"]]))
            data_df[["date"]] <- as.POSIXct(strptime(data_df[["date"]], "%Y%m%d", tz = timezone))
        if (!is.null(data_df$conversion.date))
            data_df$conversion.date <- as.POSIXct(strptime(data_df$conversion.date, "%Y%m%d", tz = timezone))
    }
    if (!is.null(data_json$containsSampledData) && isTRUE(data_json$containsSampledData)) {
        sample_perc <- as.numeric(data_json$sampleSize) / as.numeric(data_json$sampleSpace) * 100
        warning(sprintf("Data contains sampled data. Used %d sessions (%1.0f%% of sessions).", as.numeric(data_json$sampleSize), sample_perc), call. = FALSE)
    }
    names(data_json$profileInfo) <-  to_separated(names(data_json$profileInfo), sep = ".")
    names(data_json$query) <-  to_separated(names(data_json$query), sep = ".")
    attr(data_df, "profile.info") <- data_json$profileInfo
    attr(data_df, "query") <- fix_query(data_json$query)
    return(data_df)
}
