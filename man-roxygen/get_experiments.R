#' @title Experiments
#' @description Returns an experiment to which the user has access.
#' @param account.id character. Account ID to retrieve the experiment for.
#' @param experiment.id character. Experiment ID to retrieve the experiment for.
#' @param profile.id character. View (Profile) ID to retrieve the experiment for.
#' @param webproperty.id character. Web property ID to retrieve the experiment for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return The experiments collection is a set of experiment resources, each of which describes a content experiment available to an authenticated user.
#' \item{id}{Experiment ID. Required for patch and update. Disallowed for create.}
#' \item{kind}{Resource type for an Analytics experiment. This field is read-only.}
#' \item{account.id}{Account ID to which this experiment belongs. This field is read-only.}
#' \item{webproperty.id}{Web property ID to which this experiment belongs. The web property ID is of the form UA-XXXXX-YY. This field is read-only.}
#' \item{internal.webproperty.id}{Internal ID for the web property to which this experiment belongs. This field is read-only.}
#' \item{profile.id}{View (Profile) ID to which this experiment belongs. This field is read-only.}
#' \item{name}{Experiment name. This field may not be changed for an experiment whose status is ENDED. This field is required when creating an experiment.}
#' \item{description}{Notes about this experiment.}
#' \item{created}{Time the experiment was created. This field is read-only.}
#' \item{updated}{Time the experiment was last modified. This field is read-only.}
#' \item{objective.metric}{The metric that the experiment is optimizing.  Valid values: "ga:goal(n)Completions", "ga:adsenseAdsClicks", "ga:adsenseAdsViewed", "ga:adsenseRevenue", "ga:bounces", "ga:pageviews", "ga:sessionDuration", "ga:transactions", "ga:transactionRevenue". This field is required if status is "RUNNING" and servingFramework is one of "REDIRECT" or "API".}
#' \item{optimization.type}{Whether the objectiveMetric should be minimized or maximized. Possible values: "MAXIMUM", "MINIMUM". Optional--defaults to "MAXIMUM".  Cannot be specified without objectiveMetric. Cannot be modified when status is "RUNNING" or "ENDED".}
#' \item{status}{Experiment status. Possible values: "DRAFT", "READY_TO_RUN", "RUNNING", "ENDED". Experiments can be created in the "DRAFT", "READY_TO_RUN" or "RUNNING" state. This field is required when creating an experiment.}
#' \item{winner.found}{Boolean specifying whether a winner has been found for this experiment. This field is read-only.}
#' \item{start.time}{The starting time of the experiment (the time the status changed from READY_TO_RUN to RUNNING). This field is present only if the experiment has started. This field is read-only.}
#' \item{end.time}{The ending time of the experiment (the time the status changed from RUNNING to ENDED). This field is present only if the experiment has ended. This field is read-only.}
#' \item{reason.experiment.ended}{Why the experiment ended. Possible values: "STOPPED_BY_USER", "WINNER_FOUND", "EXPERIMENT_EXPIRED", "ENDED_WITH_NO_WINNER", "GOAL_OBJECTIVE_CHANGED".  "ENDED_WITH_NO_WINNER" means that the experiment didn't expire but no winner was projected to be found. If the experiment status is changed via the API to ENDED this field is set to STOPPED_BY_USER. This field is read-only.}
#' \item{rewrite.variation.urls.as.original}{Boolean specifying whether variations URLS are rewritten to match those of the original. This field may not be changed for an experiment whose status is ENDED.}
#' \item{winner.confidence.level}{A floating-point number between 0 and 1. Specifies the necessary confidence level to choose a winner. This field may not be changed for an experiment whose status is ENDED.}
#' \item{minimum.experiment.length.in.days}{An integer number in [3, 90]. Specifies the minimum length of the experiment. Can be changed for a running experiment. This field may not be changed for an experiment whose status is ENDED.}
#' \item{traffic.coverage}{A floating-point number between 0 and 1. Specifies the fraction of the traffic that participates in the experiment. Can be changed for a running experiment. This field may not be changed for an experiment whose status is ENDED.}
#' \item{equal.weighting}{Boolean specifying whether to distribute traffic evenly across all variations. If the value is False, content experiments follows the default behavior of adjusting traffic dynamically based on variation performance. Optional -- defaults to False. This field may not be changed for an experiment whose status is ENDED.}
#' \item{snippet}{The snippet of code to include on the control page(s). This field is read-only.}
#' \item{variations}{Array of variations. The first variation in the array is the original. The number of variations may not change once an experiment is in the RUNNING state. At least two variations are required before status can be set to RUNNING.}
#' \item{serving.framework}{The framework used to serve the experiment variations and evaluate the results.  One of:  REDIRECT: Google Analytics redirects traffic to different variation pages, reports the chosen variation and evaluates the results. API: Google Analytics chooses and reports the variation to serve and evaluates the results; the caller is responsible for serving the selected variation. EXTERNAL: The variations will be served externally and the chosen variation reported to Google Analytics.  The caller is responsible for serving the selected variation and evaluating the results.}
#' \item{editable.in.ga.ui}{If true, the end user will be able to edit the experiment via the Google Analytics user interface.}
#' \item{variations.name}{The name of the variation. This field is required when creating an experiment. This field may not be changed for an experiment whose status is ENDED.}
#' \item{variations.url}{The URL of the variation. This field may not be changed for an experiment whose status is RUNNING or ENDED.}
#' \item{variations.status}{Status of the variation. Possible values: "ACTIVE", "INACTIVE". INACTIVE variations are not served. This field may not be changed for an experiment whose status is ENDED.}
#' \item{variations.weight}{Weight that this variation should receive.  Only present if the experiment is running. This field is read-only.}
#' \item{variations.won}{True if the experiment has ended and this variation performed (statistically) significantly better than the original. This field is read-only.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/experiments}{Management API - Experiments Overview}
#' @family Management API
