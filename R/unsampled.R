#' @template get_unsampled_reports
#' @include mgmt.R
#' @export
get_unsampled_report <- function(account.id, webproperty.id, profile.id, unsampled.report.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports", unsampled.report.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_unsampled_reports
#' @include mgmt.R
#' @export
list_unsampled_reports <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports")
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
