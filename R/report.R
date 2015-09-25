#' @title Get the Anaytics reporting data
#'
#' @param type character. Report type. Allowed values: ga, mcf, rt.
#' @param query list. List of the data request query parameters.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the Analytics data for a view (profile).
#'
#' @keywords internal
#'
#' @include query.R
#' @include get-data.R
#' @include profiles.R
#'
#' @noRd
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize()
#' # set query
#' query <- build_query(profile.id = "XXXXXXXX", start.date = "31daysAgo", end.date = "today",
#'                      metrics = "ga:users,ga:sessions", dimensions = "ga:userType")

#' # get report data
#' ga_data <- get_report(type = "ga", query = query)
#' }
#'
get_report <- function(type = c("ga", "mcf", "realtime"), query, token) {
    type <- match.arg(type)
    data_json <- get_data(type = type, query = query, token = token)
    if (is.null(data_json)) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    data_df <- data_json$rows
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
        sample_perc <- round((as.numeric(data_json$sampleSize) / as.numeric(data_json$sampleSpace)) * 100, digits = 2)
        warning(sprintf("Data contains sampled data. Used %d sessions (%d%% of sessions).", data_json$sampleSize, sample_perc), call. = FALSE)
    }
    names(data_json$profileInfo) <-  to_separated(names(data_json$profileInfo), sep = ".")
    names(data_json$query) <-  to_separated(names(data_json$query), sep = ".")
    attr(data_df, "profile.info") <- data_json$profileInfo
    attr(data_df, "query") <- fix_query(data_json$query)
    return(data_df)
}
