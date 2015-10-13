daywise <- function(path, query, token) {
    message(sprintf("Fetch data day-by-day: from %s to %s. Batch processing mode enabled.", query$start.date, query$end.date))
    dates <- seq.Date(as.Date(query$start.date), as.Date(query$end.date), by = "day")
    res <- vector(mode = "list", length = length(dates))
    pb <- txtProgressBar(min = 0, max = length(dates), initial = 1, style = 3)
    for (i in seq_along(dates)) {
        query$start.date <- as.character(dates[i])
        query$end.date <- as.character(dates[i])
        res[[i]] <- get_report(path, query, token)
        setTxtProgressBar(pb, i)
    }
    res <- do.call(rbind, res)
    if (is.null(query$dimensions))
        res <- as.data.frame(as.list(colSums(res)))
    else if (!is.null(query$dimensions) && !any(grepl("date", query$dimensions))) {
        mets <- parse_params(query$metrics)
        dims <- parse_params(query$dimensions)
        res <- aggregate.data.frame(res[mets], res[dims], sum)
    }
    close(pb)
    if (grepl("ga:users|ga:[0-9]+dayUsers", query$metrics))
        warning(sprintf("The %s or %s total value for several days is not the sum of values for each single day.", dQuote("ga:users"), dQuote("ga:NdayUsers")), call. = FALSE)
    return(res)
}
