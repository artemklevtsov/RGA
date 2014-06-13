# Build data.frame for core report
build_ga <- function(rows, cols) {
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

# Build data.frame for mgmt
build_mgmt <- function(data, cols) {
    if (data$totalResults > 0 && !is.null(data[["items"]])) {
        data.r <- data[["items"]]
        data.r <- data.r[, names(data[["items"]]) %in% cols]
    } else {
        data.r <- data.frame(matrix(NA, nrow = 1L, ncol = length(cols)))
        colnames(data.r) <- cols
    }
    return(data.r)
}
