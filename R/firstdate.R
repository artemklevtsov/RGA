#' @title Get the first date with available data
#'
#' @param profile.id Google Analytics profile ID.
#' @param token \code{Token2.0} class object.
#'
#' @return Start date of collect of the Google Analytics statistics.
#'
#' @seealso \code{\link{authorize}} \code{\link{get_report}}
#'
#' @examples
#' \dontrun{
#' authorize(client.id = "myID", client.secret = "mySecret")
#' first.date <- get_firstdate(profile.id = "myProfileID")
#' }
#'
#' @include report.R
#'
#' @export
#'
get_firstdate <- function(profile.id, token) {
    data.r <- suppressWarnings(
        get_report(profile.id = profile.id, start.date = "2005-01-01", end.date = "today",
                   metrics = "ga:sessions", dimensions = "ga:date", filters = "ga:sessions!=0",
                   max.results = 1L, token = token, messages = FALSE)
    )
    return(data.r$date)
}
