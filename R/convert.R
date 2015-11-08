# Build data.frame for core report
core_df <- function(x) {
    res <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(res) <- x$column.headers$name
    return(res)
}

collapse_mcf <- function(x) {
    if (ncol(x) == 1)
        res <- paste(x$node.value, collapse = " > ")
    else {
        res <- paste(x$interactionType, x$nodeValue, collapse = " > ", sep = ":")
        res <- gsub("NA:", "", res, fixed = TRUE)
    }
    return(res)
}

# Build data.frame for mcf report
mcf_df <- function(x) {
    col_names <- x$column.headers$name
    idx <- grep("MCF_SEQUENCE", x$column.headers$data.type, fixed = TRUE)
    if (length(idx)) {
        primitive <- lapply(x$rows, function(i) .subset2(i, "primitiveValue")[-idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- col_names[-idx]
        conversion <- lapply(x$rows, function(i) .subset2(i, "conversionPathValue")[idx])
        conversion <- lapply(conversion, function(i) vapply(i, collapse_mcf, FUN.VALUE = character(1)))
        conversion <- do.call(rbind, conversion)
        colnames(conversion) <- col_names[idx]
        res <- data.frame(primitive, conversion, row.names = NULL, stringsAsFactors = FALSE)[, col_names]
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
    idx <- grep("\\.link$|\\.link\\.|kind", colnames(res))
    if (length(idx))
        res <- res[-idx]
    if (!is.null(res$permissions.effective)) {
        names(res) <- gsub(".effective", "", names(res), fixed = TRUE)
        res$permissions <- vapply(res$permissions, paste, collapse = ",", FUN.VALUE = character(1))
    }
    return(res)
}

# Build a data.frame for GA report data
#' @include utils.R
build_df <- function(x) {
    if (!is.null(x$column.headers)) {
        x$column.headers$name <- gsub("^.*:", "", x$column.headers$name)
        if (grepl("mcfData", x$kind, fixed = TRUE))
            res <- mcf_df(x)
        else
            res <- core_df(x)
    } else
        res <- mgmt_df(x)
    res <- convert_types.data.frame(res)
    colnames(res) <- to_separated(colnames(res))
    rownames(res) <- NULL
    return(res)
}
