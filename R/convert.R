# Build data.frame for core report
core_df <- function(x) {
    res <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(res) <- gsub("^.*:", "", x$columnHeaders$name)
    return(res)
}

collapse_mcf <- function(x) {
    if (ncol(x) == 1)
        res <- paste(x$nodeValue, collapse = " > ")
    else {
        res <- paste(x$interactionType, x$nodeValue, collapse = " > ", sep = ":")
        res <- gsub("NA:", "", res, fixed = TRUE)
    }
    return(res)
}

# Build data.frame for mcf report
mcf_df <- function(x) {
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
        res <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, col_names]
    } else {
        res <- as.data.frame(do.call(rbind, unlist(x$rows, recursive = FALSE, use.names = FALSE)),
                                 stringsAsFactors = FALSE)
        colnames(res) <- col_names
    }
    return(res)
}

# Build data.frame for mgmt data
mgmt_df <- function(x) {
    res <- x$items
    if (!is.null(res$permissions.effective)) {
        names(res) <- gsub(".effective", "", names(res), fixed = TRUE)
        res$permissions <- vapply(res$permissions, paste, collapse = ",", FUN.VALUE = character(1))
    }
    names(res) <- gsub("PropertyId", "propertyId", names(res), fixed = TRUE)
    return(res)
}

# Build a data.frame for GA report data
#' @include utils.R
build_df <- function(x) {
    if (!is.null(x$columnHeaders)) {
        if (grepl("mcfData", x$kind, fixed = TRUE))
            res <- mcf_df(x)
        else
            res <- core_df(x)
    } else
        res <- mgmt_df(x)
    rownames(res) <- NULL
    colnames(res) <- to_separated(colnames(res), sep = ".")
    res <- convert_datatypes(res)
    return(res)
}
