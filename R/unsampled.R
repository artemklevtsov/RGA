#' @template get_unsampled_reports
#' @include mgmt.R
#' @export
get_unsampled_report <- function(account.id, webproperty.id, profile.id, unsampled.report.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/unsampledReports/%s",
                    account.id, webproperty.id, profile.id, unsampled.report.id)
    get_mgmt(path, token)
}

#' @template list_unsampled_reports
#' @include mgmt.R
#' @export
list_unsampled_reports <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/unsampledReports",
                    account.id, webproperty.id, profile.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
