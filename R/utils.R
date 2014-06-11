# Reduce NULL and "" elements
compact <- function(x) {
    x <- Filter(Negate(is.null), x)
    x <- Filter(nzchar, x)
    return(x)
}

# Remove whitespace around operators
strip_ops <- function(x) {
    # available operators
    ga_ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
    ops_pattern <- paste("(\\ )+(", paste(ga_ops, collapse = "|"), ")(\\ )+", sep = "")
    # remove whitespaces around operators
    x <- gsub(ops_pattern, "\\2", x)
    # replace logical operators
    x <- gsub("OR|\\|\\|", ",", x)
    x <- gsub("AND|&&", ";", x)
}

# Build data.frame for core report
build_core <- function(rows, cols) {
    cols$name <- gsub("ga:", "", cols$name)
    data.df <- as.data.frame(rows, stringsAsFactors = FALSE)
    colnames(data.df) <- cols$name
    return(data.df)
}

# Build data.frame for mcf report
build_mcf <- function(rows, cols) {
    cols$name <- gsub("mcf:", "", cols$name)
    if ("MCF_SEQUENCE" %in% cols$dataType) {
        primitive.idx <- grep("MCF_SEQUENCE", cols$dataType, invert = TRUE)
        conversion.idx <- grep("MCF_SEQUENCE", cols$dataType)
        primitive <- lapply(rows, function(x) .subset2(x, "primitiveValue")[primitive.idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- cols$name[primitive.idx]
        conversion <- lapply(rows, function(x) .subset2(x, "conversionPathValue")[conversion.idx])
        conversion <- lapply(conversion, function(i) lapply(i, function(x) paste(apply(x, 1, paste, collapse = ":"), collapse = " > ")))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- cols$name[conversion.idx]
        data.df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, cols$name]
    } else {
        data.df <- as.data.frame(do.call(rbind, lapply(rows, unlist)), stringsAsFactors = FALSE)
        # insert column names
        colnames(data.df) <- cols$name
    }
    return(data.df)
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
