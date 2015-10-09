# Build data.frame for core report
df_ga <- function(x) {
    data_df <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(data_df) <- gsub("^ga:", "", x$columnHeaders$name)
    return(data_df)
}

# Build data.frame for realtime report
df_realtime <- function(x) {
    data_df <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(data_df) <- gsub("^rt:", "", x$columnHeaders$name)
    return(data_df)
}

collapse_mcf <- function(x) {
    if (ncol(x) == 1)
        res <- paste(x$nodeValue, collapse = " > ")
    else {
        res <- paste(x$interactionType, x$nodeValue, collapse = " > ", sep = ":")
        res <- gsub("NA:", "", res)
    }
    return(res)
}

# Build data.frame for mcf report
df_mcf <- function(x) {
    col_names <- gsub("^mcf:", "", x$columnHeaders$name)
    types <- x$columnHeaders$dataType
    if ("MCF_SEQUENCE" %in% types) {
        idx <- grep("MCF_SEQUENCE", types, fixed = TRUE)
        primitive <- lapply(x$rows, function(i) .subset2(i, "primitiveValue")[-idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- col_names[-idx]
        conversion <- lapply(x$rows, function(i) .subset2(i, "conversionPathValue")[idx])
        conversion <- lapply(conversion, function(i) vapply(i, collapse_mcf, FUN.VALUE = character(1)))
        conversion <- do.call(rbind, conversion)
        colnames(conversion) <- col_names[idx]
        data_df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, col_names]
    } else {
        data_df <- as.data.frame(do.call(rbind, unlist(x$rows, recursive = FALSE, use.names = FALSE)), stringsAsFactors = FALSE)
        colnames(data_df) <- col_names
    }
    return(data_df)
}

# Build data.frame for mgmt data
df_mgmt <- function(x) {
    data_df <- x$items
    if (!is.null(data_df$permissions.effective)) {
        names(data_df) <- gsub(".effective", "", names(data_df), fixed = TRUE)
        data_df$permissions <- vapply(data_df$permissions, paste, collapse = ",", FUN.VALUE = character(1))
    }
    names(data_df) <- gsub("PropertyId", "propertyId", names(data_df), fixed = TRUE)
    return(data_df)
}

# Build a data.frame for GA report data
#' @include utils.R
build_df <- function(data) {
    string <- data$kind
    if (grepl("gaData", string, fixed = TRUE))
        data_df <- df_ga(data)
    else if (grepl("mcfData", string, fixed = TRUE))
        data_df <- df_mcf(data)
    else if (grepl("realtimeData", string, fixed = TRUE))
        data_df <- df_realtime(data)
    else
        data_df <- df_mgmt(data)
    rownames(data_df) <- NULL
    colnames(data_df) <- to_separated(colnames(data_df), sep = ".")
    data_df <- convert_datatypes(data_df)
    return(data_df)
}
