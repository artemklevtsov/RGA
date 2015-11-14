#' @template get_unsampled_reports
#' @include mgmt.R
#' @export
get_unsampled_report <- function(account.id, webproperty.id, profile.id, unsampled.report.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/unsampledReports/%s",
                    account.id, webproperty.id, profile.id, unsampled.report.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_unsampled_reports
#' @include mgmt.R
#' @export
list_unsampled_reports <- function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/unsampledReports",
                    account.id, webproperty.id, profile.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
