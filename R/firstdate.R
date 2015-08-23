#' @title Get the first date with available data
#'
#' @param profile.id Google Analytics profile ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return Start date of collecting the Google Analytics statistics.
#'
#' @seealso \code{\link{authorize}}
#'
#' @family Reporting API
#'
#' @examples
#' \dontrun{
#' authorize()
#' first_date <- firstdate(profile.id = "profile_id")
#' ga_data <- get_ga("profile_id", start.date = first_date, end.date = "today",
#'                   metrics = "ga:sessions", dimensions = "ga:source,ga:medium",
#'                   sort = "-ga:sessions")
#' }
#'
#' @include ga.R
#'
#' @export
#'
firstdate <- function(profile.id, token) {
    res <- suppressWarnings(
        get_ga(profile.id = profile.id, start.date = "2005-01-01", end.date = "today",
               metrics = "ga:sessions", dimensions = "ga:date", filters = "ga:sessions>0",
               max.results = 1L, token = token)
    )
    return(res$date)
}
