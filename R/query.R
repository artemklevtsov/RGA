set_query <- function(profile.id, start.date = Sys.Date() - 8, end.date = Sys.Date() - 1,
                      metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = "ga:date",
                      sort = NULL, filters = NULL, segment = NULL, fields = NULL, start.index = 1L, max.results = 10000L) {
    # Checks
    stopifnot(!missing(profile.id))
    stopifnot(!is.null(start.date))
    stopifnot(!is.null(end.date))
    stopifnot(!is.null(metrics))
    stopifnot(length(metrics) == 1L)
    stopifnot(length(dimensions) == 1L)
    if (length(strsplit(metrics, split = ",")[[1L]]) > 10L)
        stop("Not allowd more than 10 metrics.")
    if (length(strsplit(dimensions, split = ",")[[1L]]) > 7L)
        stop("Not allowd more than 7 dimensions.")
    if (!grepl("ga:|mcf:", metrics))
        stop("Invalid metrics: add 'ga:' or 'mcf:' prefix.")
    if (!grepl("ga:|mcf:", dimensions))
        stop("Invalid dimensions: add 'ga:' or 'mcf:' prefix.")
    if (!is.null(sort))
        stopifnot(length(sort) == 1L)
    if (!is.null(filters)) {
        stopifnot(length(filters) == 1L)
        # available operators
        ops <- c("==", "!=", ">", "<", ">=", "<=", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
        # make pattern for gsub
        opsw <- paste("(\\ )+(", paste(ops, collapse = "|"), ")(\\ )+", sep = "")
        # remove whitespaces around operators
        filters <- gsub(opsw, "\\2", filters)
        # replace logical operators
        filters <- gsub("OR|\\|\\|", ",", filters)
        filters <- gsub("AND|&&", ";", filters)
    }
    if (max.results > 10000L)
        stop("Not allowed max.results more then 10000.")
    # Fix profile ID
    if (!grepl("ga:", profile.id))
        profile.id <- paste("ga:", profile.id, sep = "")
    if (nchar(profile.id) != 11L)
        stop("Profile ID length must be equal 11 symbols.")
    # Remove whitespaces
    metrics <- gsub("\\s", "", metrics)
    dimensions <- gsub("\\s", "", dimensions)
    # Build query
    query <- list(profile.id = profile.id,
                  start.date = as.character(start.date),
                  end.date = as.character(end.date),
                  metrics = metrics,
                  dimensions = dimensions,
                  sort = sort,
                  filters = filters,
                  segment = segment,
                  start.index = start.index,
                  max.results = max.results)
    class(query) <- c("list", "GAQuery")
    if (grepl("mcf:", metrics) && grepl("mcf:", dimensions))
        class(query) <- c(class(query), "mcf")
    else if (grepl("ga:", metrics) && grepl("ga:", dimensions))
        class(query) <- c(class(query), "ga")
    else
        stop("Metrics and dimensions should have same prefix: ga or mcf.")
    return(query)
}

as.character.GAQuery <- function(x) {
    x <- compact(x)
    params <- gsub("\\.", "-", names(x))
    params <- gsub("profile.id", "ids", params)
    values <- as.vector(x, mode = "character")
    values <- curlEscape(values)
    string <- paste(params, values, sep = "=", collapse = "&")
    return(string)
}

print.GAQuery <- function(x) {
    if (inherits(x, "mcf"))
        x <- c(report.type = "multi-channel funnels", x)
    else if (inherits(x, "ga"))
        x <- c(report.type = "core", x)
    x <- compact(x)
    cat("<Google Analytics Query>\n")
    cat(paste0("  ", format(paste0(names(x), ": ")), unlist(x), collapse = "\n"))
    cat("\n")
}
