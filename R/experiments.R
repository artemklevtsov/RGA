#' @template get_experiments
#' @include mgmt.R
#' @export
get_experiment <- function(account.id, webproperty.id, profile.id, experiment.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "experiments", experiment.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_experiments
#' @include mgmt.R
#' @export
list_experiments <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "experiments")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,profileId,name,description,objectiveMetric,optimizationType,status,winnerFound,rewriteVariationUrlsAsOriginal,winnerConfidenceLevel,startTime,endTime,minimumExperimentLengthInDays,reasonExperimentEnded,editableInGaUi,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
