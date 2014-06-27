#' @title A Google Analytics API client for R
#'
#' @description
#' This is a package for extracting data from Google Analytics API into R.
#'
#' @section Supported Features:
#'
#' \itemize{
#'   \item Support for \href{https://developers.google.com/accounts/docs/OAuth2}{OAuth 2.0 authorization};
#'   \item Access to following \href{https://developers.google.com/analytics/devguides/platform/}{Google Analytics APIs}:
#'   \itemize{
#'     \item \href{https://developers.google.com/analytics/devguides/config/mgmt/v3}{Management API}: access configuration data for accounts, web properties, views (profiles), goals and segments;
#'     \item \href{https://developers.google.com/analytics/devguides/reporting/core/v3}{Core Reporting API}: query for dimensions and metrics to produce customized reports;
#'     \item {https://developers.google.com/analytics/devguides/reporting/mcf/v3}{Multi-Channel Funnels Reporting API}: query the traffic source paths that lead to a user's goal conversion;
#'     \item \href{https://developers.google.com/analytics/devguides/reporting/realtime/v3}{Real Time Reporting API}: report on activity occurring on your property right now;
#'     \item \href{https://developers.google.com/analytics/devguides/reporting/metadata/v3}{Metadata API}: access the list of API dimensions and metrics and their attributes;
#'   }
#'   \item Support of the batch processing of the requests (allows to overcome the restriction on the number of rows returned for a single request).
#' }
#'
#' @author
#' Artem Klevtsov \email{a.a.klevtsov@@gmail.com}
#'
#' @name RGA
#' @docType package
#' @keywords package
#' @aliases rga RGA-package
#'
#' @references
#' \href{https://console.developers.google.com/project}{Google Developers Console}
#'
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/}{The Management API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/}{The Core Reporting API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/mcf/v3/}{The Multi-Channel Funnels Reporting API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/realtime/v3/}{The Real Time Reporting API}
#'
#' @examples
#' \dontrun{
#' # load package
#' library(RGA)
#' # get access token
#' authorize(client.id = "myClientID", client.secret = "myClientSecret", cache = FALSE)
#' # get a GA profiles
#' ga_profiles <- get_profiles()
#' # choose the profile ID by site URL
#' profile.id <- ga_profiles[ga_profiles$websiteUrl == "mySiteURL", "id"]
#' # get date when GA tracking began
#' first.date <- get_firstdate(profile.id)
#' # get GA report data
#' ga_data <- get_ga(profile.id, start.date = first.date, end.date = "today",
#'                   metrics = "ga:users,ga:sessions", dimensions = "ga:userGender,ga:userAgeBracket")
#' }
#'
NULL
