#' @title A Google Analytics client for R
#'
#' @description
#' This is a package for extracting data from Google Analytics into R. The package uses OAuth 2.0 (protocol) to access the Google Analytics API.
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
#' Google Developers Console: \url{https://console.developers.google.com/project}
#'
#' The Management API: \url{https://developers.google.com/analytics/devguides/config/mgmt/v3}
#'
#' The Core Reporting API: \url{https://developers.google.com/analytics/devguides/reporting/core/v3}
#'
#' The Multi-Channel Funnels Reporting API: \url{https://developers.google.com/analytics/devguides/reporting/mcf/v3}
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
#' ga_data <- get_report(profile.id, start.date = first.date, end.date = "today",
#'                       metrics = "ga:users,ga:sessions",
#'                       dimensions = "ga:userGender,ga:userAgeBracket")
#' }
#'
NULL
