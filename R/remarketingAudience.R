#' @template get_remarketingAudience
#' @include mgmt.R
#' @export
get_remarketing_audience <- function(accountId, webPropertyId, remarketingAudienceId, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/remarketingAudiences/%s",
                    accountId, webPropertyId, customDimensionId)
    get_mgmt(path, token)
}

#' @template list_remarketingAudience
#' @include mgmt.R
#' @export
list_remarketing_audiences <- function(accountId, webPropertyId, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/remarketingAudiences",
                    accountId, webPropertyId)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
