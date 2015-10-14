date_ranges <- function(start, end, by) {
    start <- as.Date(start)
    end <- as.Date(end)
    by <- match.arg(by, c("day", "week", "month", "quarter", "year"))
    dates <- seq.Date(start, end, by = by)
    res <- data.frame(start = as.character(dates),
                      end = as.character(c(dates[-1] - 1, end)),
                      stringsAsFactors = FALSE)
    return(res)
}

parse_date <- function(x) {
    stopifnot(is.character(x))
    if (grepl("[0-9]+daysAgo", x))
        x <-  Sys.Date() - as.numeric(sub("([0-9]+).*", "\\1", x))
    else if (x == "today")
        x <- Sys.Date()
    else if (x == "yesterday")
        x <- Sys.Date() - 1
    return(as.character(x))
}

datewise <- function(path, query, by, token) {
    query$start.date <- parse_date(query$start.date)
    query$end.date <- parse_date(query$end.date)
    dates <- date_ranges(query$start.date, query$end.date, by)
    n <- nrow(dates)
    message(sprintf("Fetch data day-by-day: from %s to %s. Batch processing mode enabled.", query$start.date, query$end.date))
    res <- vector(mode = "list", length = n)
    pb <- txtProgressBar(min = 0, max = n, initial = 1, style = 3)
    for (i in 1:n) {
        query$start.date <- dates$start[i]
        query$end.date <- dates$end[i]
        res[[i]] <- get_report(path, query, token)
        setTxtProgressBar(pb, i)
    }
    attrs <- attributes(res[[1]])
    attrs$query$start.date <-  attr(res[[1]], "query")$start.date
    attrs$query$end.date <- attr(res[[n]], "query")$end.date
    res <- do.call(rbind, res)
    if (is.null(query$dimensions))
        res <- as.data.frame(as.list(colSums(res)))
    else if (!is.null(query$dimensions) && !any(grepl("date", query$dimensions))) {
        mets <- parse_params(query$metrics)
        dims <- parse_params(query$dimensions)
        res <- aggregate.data.frame(res[mets], res[dims], sum)
    }
    attributes(res) <- attrs
    close(pb)
    if (grepl("ga:users|ga:[0-9]+dayUsers", query$metrics))
        warning(sprintf("The %s or %s total value for several days is not the sum of values for each single day.", dQuote("ga:users"), dQuote("ga:NdayUsers")), call. = FALSE)
    return(res)
}
