#' @title Custom Data Sources
#' 
#' @description List custom data sources to which the user has access.
#' 
#' @param account.id character. Account Id for the custom data sources to retrieve.
#' @param webproperty.id character. Web property Id for the custom data sources to retrieve.
#' @param max.results integer. The maximum number of custom data sources to include in this response.
#' @param start.index integer. A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' 
#' @return The customDataSources collection is a set of customDataSource resources, each of which describes a custom data source available to an authenticated user.
#' \item{id}{Custom data source ID.}
#' \item{kind}{Resource type for Analytics custom data source.}
#' \item{account.id}{Account ID to which this custom data source belongs.}
#' \item{webproperty.id}{Web property ID of the form UA-XXXXX-YY to which this custom data source belongs.}
#' \item{name}{Name of this custom data source.}
#' \item{description}{Description of custom data source.}
#' \item{type}{Type of the custom data source.}
#' \item{upload.type}{The resource type with which the custom data source can be used to upload data; it can have the values "analytics#uploads" or "analytics#dailyUploads". Custom data sources with this property set to "analytics#dailyUploads" are deprecated and should be migrated using the uploads resource.}
#' \item{import.behavior}{How cost data metrics are treated when there are duplicate keys. If this property is set to "SUMMATION" the values are added; if this property is set to "OVERWRITE" the most recent value overwrites the existing value.}
#' \item{profiles.linked}{IDs of views (profiles) linked to the custom data source.}
#' \item{created}{Time this custom data source was created.}
#' \item{updated}{Time this custom data source was last modified.}
#' 
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDataSources}{Management API - Custom Data Sources Overview}
#' 
#' @family Management API
