# Build data.frame for core report
build_ga <- function(data, cols) {
    cols$name <- gsub("^(ga|rt):", "", cols$name)
    data_df <- as.data.frame(data, stringsAsFactors = FALSE)
    colnames(data_df) <- cols$name
    return(data_df)
}

# Build data.frame for mcf report
build_mcf <- function(data, cols) {
    cols$name <- gsub("^mcf:", "", cols$name)
    if ("MCF_SEQUENCE" %in% cols$dataType) {
        primitive.idx <- grep("MCF_SEQUENCE", cols$dataType, invert = TRUE)
        conversion.idx <- grep("MCF_SEQUENCE", cols$dataType)
        primitive <- lapply(data, function(x) .subset2(x, "primitiveValue")[primitive.idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- cols$name[primitive.idx]
        conversion <- lapply(data, function(x) .subset2(x, "conversionPathValue")[conversion.idx])
        conversion <- lapply(conversion, function(i) lapply(i, function(x) paste(apply(x, 1, paste, collapse = ":"), collapse = " > ")))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- cols$name[conversion.idx]
        data_df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, cols$name]
    } else {
        data_df <- as.data.frame(do.call(rbind, lapply(data, unlist)), stringsAsFactors = FALSE)
        colnames(data_df) <- cols$name
    }
    return(data_df)
}

build_mgmt <- function(data, cols) {
    if (inherits(data, "matrix") || inherits(data, "data.frame"))
        data_df <- data[, names(data) %in% cols]
    else if (inherits(data, "list")) {
        cn <- unlist(lapply(data, colnames))
        ctab <- table(cn)
        cn <- names(ctab)[ctab == length(data)]
        data <- lapply(data, function(x) x[cn])
        data <- lapply(data, function(x) x[, names(x) %in% cols])
        data_df <- do.call(rbind, data)
    }
    return(data_df)
}

# Build a data.frame for GA report data
build_df <- function(type = c("ga", "mcf", "rt", "mgmt"), data, cols, verbose = getOption("rga.verbose", FALSE)) {
    if (verbose)
        message("Building data frame...")
    type <- match.arg(type)
    data_df <- switch(type,
                      ga = build_ga(data, cols),
                      rt = build_ga(data, cols),
                      mcf = build_mcf(data, cols),
                      mgmt = build_mgmt(data, cols))
    if (verbose)
        message(paste("Obtained data.frame with", nrow(data_df), "rows and", ncol(data_df), "columns."))
    return(data_df)
}

# Convert data types
convert_datatypes <- function(data, formats) {
    formats[formats %in% c("INTEGER", "PERCENT", "TIME", "CURRENCY", "FLOAT")] <- "numeric"
    formats[formats == "STRING"] <- "character"
    formats[formats == "MCF_SEQUENCE"] <- "character"
    data[] <- lapply(seq_along(formats), function(i) as(data[[i]], Class = formats[i]))
    if ("date" %in% colnames(data)) {
        data$date <- as.Date(data$date, "%Y%m%d")
    }
    if ("conversionDate" %in% colnames(data)) {
        data$conversionDate <-as.Date(data$conversionDate, "%Y%m%d")
    }
    return(data)
}
