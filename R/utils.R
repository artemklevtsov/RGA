# Reduce NULL and "" elements
compact <- function(x) {
    x <- Filter(Negate(is.null), x)
    x <- Filter(nzchar, x)
    x <- Filter(length, x)
    return(x)
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
