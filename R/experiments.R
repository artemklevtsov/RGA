#' @title Experiments
#'
#' @description Gets a experiment to which the user has access to.
#'
#' @param account.id integer or character. Account ID to retrieve the experiment for.
#' @param webproperty.id integer or character. Web property ID to retrieve the experiment for.
#' @param profile.id integer or character. View (Profile) ID to retrieve the experiment for.
#' @param experiment.id integer or character. Experiment ID to retrieve the experiment for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics experiment resource.
#' \item{id}{Experiment ID. Required for patch and update.}
#' \item{kind}{Resource type for an Analytics experiment.}
#' \item{self.link}{Link for this experiment.}
#' \item{account.id}{Account ID to which this experiment belongs.}
#' \item{webproperty.id}{Web property ID to which this experiment belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{internal.webproperty.id}{Internal ID for the web property to which this experiment belongs.}
#' \item{profile.id}{View (Profile) ID to which this experiment belongs.}
#' \item{name}{Experiment name. This field is required when creating an experiment.}
#' \item{description}{Notes about this experiment.}
#' \item{created}{Time the experiment was created.}
#' \item{updated}{Time the experiment was last modified.}
#' \item{objective.metric}{The metric that the experiment is optimizing.}
#' \item{status}{Experiment status. Possible values: "DRAFT", "READY_TO_RUN", "RUNNING", "ENDED". Experiments can be created in the "DRAFT", "READY_TO_RUN" or "RUNNING" state. This field is required when creating an experiment.}
#' \item{winner.found}{Boolean specifying whether a winner has been found for this experiment.}
#' \item{start.time}{The starting time of the experiment (the time the status changed from READY_TO_RUN to RUNNING). This field is present only if the experiment has started.}
#' \item{end.time}{The ending time of the experiment (the time the status changed from RUNNING to ENDED). This field is present only if the experiment has ended.}
#' \item{reason.experiment.ended}{Why the experiment ended. Possible values: "STOPPED_BY_USER", "WINNER_FOUND", "EXPERIMENT_EXPIRED", "ENDED_WITH_NO_WINNER", "GOAL_OBJECTIVE_CHANGED". "ENDED_WITH_NO_WINNER" means that the experiment didn't expire but no winner was projected to be found. If the experiment status is changed via the API to ENDED this field is set to STOPPED_BY_USER.}
#' \item{rewrite.variation.urls.as.original}{Boolean specifying whether variations URLS are rewritten to match those of the original.}
#' \item{winner.confidence.level}{A floating-point number between 0 and 1. Specifies the necessary confidence level to choose a winner.}
#' \item{minimum.experiment.length.in.days}{An integer number in [3, 90]. Specifies the minimum length of the experiment. Can be changed for a running experiment.}
#' \item{traffic.coverage}{A floating-point number between 0 and 1. Specifies the fraction of the traffic that participates in the experiment. Can be changed for a running experiment.}
#' \item{equal.weighting}{Boolean specifying whether to distribute traffic evenly across all variations. If the value is False, content experiments follows the default behavior of adjusting traffic dynamically based on variation performance. Optional -- defaults to False.}
#' \item{snippet}{The snippet of code to include on the control page(s).}
#' \item{serving.framework}{The framework used to serve the experiment variations and evaluate the results.}
#' \item{editable.in.ga.ui}{If true, the end user will be able to edit the experiment via the Google Analytics user interface.}
#' \item{parent.link}{Parent link for an experiment. Points to the view (profile) to which this experiment belongs.}
#' \item{variations}{Array of variations. The first variation in the array is the original. The number of variations may not change once an experiment is in the RUNNING state. At least two variations are required before status can be set to RUNNING.}
#' \item{variations.name}{The name of the variation.}
#' \item{variations.url}{The URL of the variation.}
#' \item{variations.status}{Status of the variation.}
#' \item{variations.weight}{Weight that this variation should receive.}
#' \item{variations.won}{True if the experiment has ended and this variation performed (statistically) significantly better than the original.}
#' \item{parent.link.type}{Value is "analytics#profile".}
#' \item{parent.link.href}{Link to the view (profile) to which this experiment belongs.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/experiments}{Management API - Experiments}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_experiment <- function(account.id, webproperty.id, profile.id, experiment.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "experiments", experiment.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Experiments
#'
#' @description Lists experiments to which the user has access to.
#'
#' @param account.id Account ID to retrieve experiments for.
#' @param webproperty.id Web property ID to retrieve experiments for.
#' @param profile.id View (Profile) ID to retrieve experiments for.
#' @param max.results integer. The maximum number of experiments to include in this response.
#' @param start.index integer. An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An experiment collection lists Analytics experiments to which the user has access. Each view (profile) can have a set of experiments. Each resource in the Experiment collection corresponds to a single Analytics experiment.
#' \item{id}{Experiment ID. Required for patch and update. Disallowed for create.}
#' \item{account.id}{Account ID to which this experiment belongs.}
#' \item{webproperty.id}{Web property ID to which this experiment belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this experiment belongs.}
#' \item{name}{Experiment name. This field may not be changed for an experiment whose status is ENDED.}
#' \item{description}{Notes about this experiment.}
#' \item{objective.metric}{The metric that the experiment is optimizing.}
#' \item{optimization.type}{Whether the objectiveMetric should be minimized or maximized.}
#' \item{status}{Experiment status.}
#' \item{winner.found}{Boolean specifying whether a winner has been found for this experiment.}
#' \item{rewrite.variation.urls.as.original}{Boolean specifying whether variations URLS are rewritten to match those of the original.}
#' \item{winner.confidence.level}{A floating-point number between 0 and 1. Specifies the necessary confidence level to choose a winner.}
#' \item{start.time}{The starting time of the experiment (the time the status changed from READY_TO_RUN to RUNNING).}
#' \item{end.time}{The ending time of the experiment (the time the status changed from RUNNING to ENDED).}
#' \item{minimum.experiment.length.in.days}{An integer number in [3, 90]. Specifies the minimum length of the experiment.}
#' \item{reason.experiment.ended}{Why the experiment ended.}
#' \item{editable.in.ga.ui}{If true, the end user will be able to edit the experiment via the Google Analytics user interface.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/experiments}{Management API - Experiments}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_experiments <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "experiments")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,profileId,name,description,objectiveMetric,optimizationType,status,winnerFound,rewriteVariationUrlsAsOriginal,winnerConfidenceLevel,startTime,endTime,minimumExperimentLengthInDays,reasonExperimentEnded,editableInGaUi,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
