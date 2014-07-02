#' @title Get Gogole Analytics report data
#'
#' @inheritParams get_report
#' @param total.results total number of rows in the query result.
#'
#' @return List or matrix.
#'
#' @noRd
#'
#' @include get-data.R
#'
get_rows <- function(type = c("ga", "mcf", "rt"), query, total.results, token, verbose = FALSE) {
    type <- match.arg(type)
    if (!is.null(query$max.results)) {
        stopifnot(query$max.results <= 10000)
        if (query$max.results < total.results)
            warning(paste("Only", query$max.results, "observations out of", total.results, "were obtained (set max.results = NULL to get all results)."))
        data.json <- get_data(type = type, query = query, token = token, verbose = verbose)
        rows <- data.json$rows
    } else {
        if (total.results <= 10000) {
            query$max.results <- total.results
            data.json <- get_data(type = type, query = query, token = token, verbose = verbose)
            rows <- data.json$rows
        } else {
            if (verbose)
                message("Response contain more then 10000 rows.")
            query$max.results <- 10000L
            if (type == "rt") {
                warning(paste("Only", query$max.results, "observations out of", total.results, "were obtained (the batch processing mode is not implemented for this report type)."))
                data.json <- get_data(type = type, query = query, token = token, verbose = verbose)
                rows <- data.json$rows
            } else {
                total.pages <- ceiling(total.results / query$max.results)
                rows <- vector(mode = "list", length = total.pages)
                for (page in 1:total.pages) {
                    if (verbose)
                        message(paste0("Fetching page ", page, " of ", total.pages, "..."))
                    query$start.index <- query$max.results * (page - 1) + 1
                    data.json <- get_data(type = type, query = query, token = token, verbose = verbose)
                    rows[[page]] <- data.json$rows

                }
                if (inherits(rows[[1]], "matrix") || inherits(rows[[1]], "data.frame"))
                    rows <- do.call(rbind, rows)
                else if (inherits(rows[[1]], "list"))
                    rows <- do.call(c, rows)
            }
        }
    }
    return(rows)
}
