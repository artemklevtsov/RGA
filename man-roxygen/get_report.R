#' @param profile.id character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param start.date character. Start date for fetching Analytics data. Request can specify a start date formatted as "YYYY-MM-DD" or as a relative date (e.g., "today", "yesterday", or "7daysAgo"). The default value is "7daysAgo".
#' @param end.date character. End date for fetching Analytics data. Request can specify an end date formatted as "YYYY-MM-DD" or as a relative date (e.g., "today", "yesterday", or "7daysAgo"). The default value is "yesterday".
#' @param sampling.level character. The desired sampling level. Allowed values: "DEFAULT", "FASTER", "HIGHER_PRECISION".
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param fetch.by character. Split the query by date range. Allowed values: "day", "week", "month", "quarter", "year".
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data. 
#' @family Reporting API
