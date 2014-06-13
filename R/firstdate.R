#' @title Get the first date with available data
#'
#' @param profile.id Google Analytics profile ID.
#' @param date.format date format for output data.
#' @param token \code{Token2.0} class object.
#'
#' @return Start date of collect of the Google Analytics statistics.
#'
#' @seealso \code{\link{get_token}} \code{\link{get_report}}
#'
#' @examples
#' \dontrun{
#' first.date <- get_firstdate(profile.id = "myProfileID", token = ga_token)
#' }
#'
#' @include report.R
#'
#' @export
#'
get_firstdate <- function(profile.id, date.format = "%Y-%m-%d", token) {
    data.r <- get_report(profile.id = profile.id, start.date = "2005-01-01",
                         metrics = "ga:sessions", dimensions = "ga:date", filters = "ga:sessions!=0",
                         date.format = date.format, max.results = 1L, token = token, messages = FALSE)
    return(data.r$date)
}
