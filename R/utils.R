# Reduce NULL and "" elements
compact <- function(x) {
    x <- Filter(Negate(is.null), x)
    x <- Filter(nzchar, x)
    return(x)
}

# Build URL path
build_path <- function(x) {
    stopifnot(inherits(x, "list"))
    x <- compact(x)
    params <- names(x)
    params <- gsub("\\.", "-", params)
    values <- as.vector(x, mode = "character")
    string <- paste(params, values, sep = "/", collapse = "/")
    string <- gsub("//", "/", string)
    return(string)
}

# Build URL query string
#' @import RCurl
build_query <- function(x) {
    stopifnot(inherits(x, "list"))
    x <- compact(x)
    params <- names(x)
    params <- gsub("\\.", "-", params)
    params <- gsub("profile-id", "ids", params)
    values <- as.vector(x, mode = "character")
    values <- curlEscape(values)
    string <- paste(params, values, sep = "=", collapse = "&")
    return(string)
}

# Build URL
build_url <- function(type = c("ga", "mcf", "mgmt"), path, query) {
    type <- match.arg(type)
    url <- switch(type,
                  ga = "https://www.googleapis.com/analytics/v3/data/ga",
                  mcf = "https://www.googleapis.com/analytics/v3/data/mcf",
                  mgmt = "https://www.googleapis.com/analytics/v3/management",
                  stop("Unknown report type."))
    if (!missing(path)) {
        if (length(path) > 1L)
            path <- build_path(path)
        if(nzchar(path))
            url <- paste(url, path, sep = "/")
    }
    if (!missing(query)) {
        if (length(query) > 1L)
            query <- build_query(query)
        if(nzchar(query))
            url <- paste(url, query, sep = "?")
    }
    return(url)
}

# Remove whitespace around operators
strip_ops <- function(x) {
    # available operators
    ga_ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
    # build pattern for replace
    ops_pattern <- paste("(\\s)+(", paste(ga_ops, collapse = "|"), ")(\\s)+", sep = "")
    # remove whitespaces around operators
    x <- gsub(ops_pattern, "\\2", x)
    # replace logical operators
    x <- gsub("OR|\\|\\|", ",", x)
    x <- gsub("AND|&&", ";", x)
    return(x)
}

# Convert data types
convert_datatypes <- function(data, formats, date.format) {
    formats[formats %in% c("INTEGER", "PERCENT", "TIME", "CURRENCY", "FLOAT")] <- "numeric"
    formats[formats == "STRING"] <- "character"
    formats[formats == "MCF_SEQUENCE"] <- "character"
    data[] <- lapply(seq_along(formats), function(i) as(data[[i]], Class = formats[i]))
    if ("date" %in% colnames(data)) {
        data$date <- format(as.Date(data$date, "%Y%m%d"), date.format)
    }
    if ("conversionDate" %in% colnames(data)) {
        data$conversionDate <- format(as.Date(data$conversionDate, "%Y%m%d"), date.format)
    }
    return(data)
}
