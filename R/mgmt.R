get_mgmt_url <- function(type = c("accounts", "webproperties", "profiles", "goals", "segments"),
                         start.index = 1L, max.results = 1000L, ...) {
    url <- "https://www.googleapis.com/analytics/v3/management"
    type <- match.arg(type)
    dots <- list(...)
}
