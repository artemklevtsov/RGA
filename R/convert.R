# Build data.frame for core report
core_df <- function(x) {
    res <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(res) <- x$columnHeaders$name
    return(res)
}

# Collpase node values
collapse_mcf <- function(x) {
    if (is.list(x) && !is.data.frame(x))
        vapply(x, collapse_mcf, character(1))
    else
        paste(x$nodeValue, collapse = " > ")
}

# Build data.frame for mcf report
mcf_df <- function(x) {
    col_names <- x$columnHeaders$name
    idx <- grep("MCF_SEQUENCE", x$columnHeaders$dataType, fixed = TRUE)
    if (length(idx)) {
        primitive <- lapply(x$rows, function(i) .subset2(i, "primitiveValue")[-idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- col_names[-idx]
        conversion <- lapply(x$rows, function(i) .subset2(i, "conversionPathValue")[idx])
        conversion <- lapply(conversion, collapse_mcf)
        conversion <- do.call(rbind, conversion)
        colnames(conversion) <- col_names[idx]
        res <- data.frame(primitive, conversion, row.names = NULL, stringsAsFactors = FALSE)[, col_names]
    } else {
        res <- as.data.frame(do.call(rbind, unlist(x$rows, recursive = FALSE, use.names = FALSE)), stringsAsFactors = FALSE)
        colnames(res) <- col_names
    }
    return(res)
}

# Build data.frame for mgmt data
mgmt_df <- function(x) {
    res <- x$items
    idx <- grep("Link|kind", colnames(res))
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
    if (!is.null(x$columnHeaders)) {
        x$columnHeaders$name <- gsub("^.*:", "", x$columnHeaders$name)
        if (grepl("mcfData", x$kind, fixed = TRUE))
            res <- mcf_df(x)
        else
            res <- core_df(x)
        toconvert <- x$columnHeaders$columnType == "METRIC" & x$columnHeaders$dataType != "STRING"
        res[toconvert] <- lapply(res[toconvert], utils::type.convert, as.is = TRUE)
    } else
        res <- mgmt_df(x)
    colnames(res) <- rename_params(colnames(res))
    rownames(res) <- NULL
    return(res)
}
