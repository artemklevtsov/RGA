#' @title Remarketing Audiences
#' @description Gets a remarketing audience to which the user has access.
#' @param Path parameters Path parameters. Path parameters
#' @param accountId character. The account ID of the remarketing audience to retrieve.
#' @param remarketingAudienceId character. The ID of the remarketing audience to retrieve.
#' @param webPropertyId character. The web property ID of the remarketing audience to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return
#' \item{kind}{Collection type.}
#' \item{id}{Remarketing Audience ID.}
#' \item{accountId}{Account ID to which this remarketing audience belongs.}
#' \item{webPropertyId}{Web property ID of the form UA-XXXXX-YY to which this remarketing audience belongs.}
#' \item{internalWebPropertyId}{Internal ID for the web property to which this remarketing audience belongs.}
#' \item{created}{Time this remarketing audience was created.}
#' \item{updated}{Time this remarketing audience was last modified.}
#' \item{name}{The name of this remarketing audience.}
#' \item{description}{The description of this remarketing audience.}
#' \item{linkedAdAccounts}{The linked ad accounts  associated with this remarketing audience. A remarketing audience can have only one linkedAdAccount currently.}
#' \item{linkedViews}{The views (profiles) that this remarketing audience is linked to.}
#' \item{audienceType}{The type of audience, either SIMPLE or STATE_BASED.}
#' \item{audienceDefinition}{The simple audience definition that will cause a user to be added to an audience.}
#' \item{stateBasedAudienceDefinition}{A state based audience definition that will cause a user to be added or removed from an audience.}
#' \item{linkedAdAccounts.kind}{Resource type for linked foreign account.}
#' \item{linkedAdAccounts.id}{Entity ad account link ID.}
#' \item{linkedAdAccounts.accountId}{Account ID to which this linked foreign account belongs.}
#' \item{linkedAdAccounts.webPropertyId}{Web property ID of the form UA-XXXXX-YY to which this linked foreign account belongs.}
#' \item{linkedAdAccounts.internalWebPropertyId}{Internal ID for the web property to which this linked foreign account belongs.}
#' \item{linkedAdAccounts.remarketingAudienceId}{Remarketing audience ID to which this linked foreign account belongs.}
#' \item{linkedAdAccounts.linkedAccountId}{The foreign account ID. For example the an AdWords `linkedAccountId` has the following format XXX-XXX-XXXX.}
#' \item{linkedAdAccounts.type}{The type of the foreign account. For example `ADWORDS_LINKS`.}
#' \item{linkedAdAccounts.status}{The status of this foreign account link.}
#' \item{linkedAdAccounts.eligibleForSearch}{Boolean indicating whether this is eligible for search.}
#' \item{audienceDefinition.includeConditions.kind}{Resource type for include conditions.}
#' \item{audienceDefinition.includeConditions.isSmartList}{Boolean indicating whether this segment is a smart list. https://support.google.com/analytics/answer/4628577}
#' \item{audienceDefinition.includeConditions.segment}{The segment condition that will cause a user to be added to an audience.}
#' \item{audienceDefinition.includeConditions.membershipDurationDays}{Number of days a user remains in the audience. Use any integer from 1-540. In remarketing audiences for search ads, membership duration is truncated to 180 days.}
#' \item{audienceDefinition.includeConditions.daysToLookBack}{The look-back window lets you specify a time frame for evaluating the behavior that qualifies users for your audience. For example, if your filters include users from Central Asia, and Transactions Greater than 2, and you set the look-back window to 14 days, then any user from Central Asia whose cumulative transactions exceed 2 during the last 14 days is added to the audience.}
#' \item{stateBasedAudienceDefinition.includeConditions.kind}{Resource type for include conditions.}
#' \item{stateBasedAudienceDefinition.includeConditions.isSmartList}{Boolean indicating whether this segment is a smart list. https://support.google.com/analytics/answer/4628577}
#' \item{stateBasedAudienceDefinition.includeConditions.segment}{The segment condition that will cause a user to be added to an audience.}
#' \item{stateBasedAudienceDefinition.includeConditions.membershipDurationDays}{Number of days a user remains in the audience. Use any integer from 1-540. In remarketing audiences for search ads, membership duration is truncated to 180 days.}
#' \item{stateBasedAudienceDefinition.includeConditions.daysToLookBack}{The look-back window lets you specify a time frame for evaluating the behavior that qualifies users for your audience. For example, if your filters include users from Central Asia, and Transactions Greater than 2, and you set the look-back window to 14 days, then any user from Central Asia whose cumulative transactions exceed 2 during the last 14 days is added to the audience.}
#' \item{stateBasedAudienceDefinition.excludeConditions.segment}{The segment condition that will cause a user to be removed from an audience.}
#' \item{stateBasedAudienceDefinition.excludeConditions.exclusionDuration}{Whether to make the exclusion TEMPORARY or PERMANENT.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/remarketingAudience}{Management API - Remarketing Audiences Overview}
#' @family Management API
