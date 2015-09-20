# Build data.frame for core report
df_ga <- function(x) {
    if (is.list(x$rows))
        x$rows <- do.call(rbind, x$rows)
    col_names <- gsub("^ga:", "", x$columnHeaders$name)
    data_df <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(data_df) <- col_names
    return(data_df)
}

# Build data.frame for realtime report
df_realtime <- function(x) {
    col_names <- gsub("^rt:", "", x$columnHeaders$name)
    data_df <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(data_df) <- col_names
    return(data_df)
}

# Build data.frame for mcf report
df_mcf <- function(x) {
    if (is.list(x$rows[[1L]]) && !is.data.frame(x$rows[[1L]]))
        x$rows <- do.call(c, x$rows)
    col_names <- gsub("^mcf:", "", x$columnHeaders$name)
    types <- x$columnHeaders$dataType
    if ("MCF_SEQUENCE" %in% types) {
        idx <- grep("MCF_SEQUENCE", types, fixed = TRUE)
        primitive <- lapply(x$rows, function(i) .subset2(i, "primitiveValue")[-idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- col_names[-idx]
        conversion <- lapply(x$rows, function(i) .subset2(i, "conversionPathValue")[idx])
        conversion <- lapply(conversion, function(i) lapply(i, function(j) paste(j$interactionType, j$nodeValue, sep = ":", collapse = " > ")))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- col_names[idx]
        data_df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, col_names]
    } else {
        data_df <- as.data.frame(do.call(rbind, lapply(x$rows, unlist)), stringsAsFactors = FALSE)
        colnames(data_df) <- col_names
    }
    return(data_df)
}

# Rename list with sublists for mgmt data
#' @include utils.R
ls_mgmt <- function(x) {
    x <- x[!names(x) %in% c("selfLink", "parentLink", "childLink")]
    names(x) <-  to_separated(names(x), sep = ".")
    to_rename <- vapply(x, is.list, logical(1))
    x[to_rename] <- lapply(x[to_rename], function(x) stats::setNames(x, to_separated(names(x), sep = ".")))
    return(x)
}

# Build data.frame for mgmt data
df_mgmt <- function(x) {
    if (is.data.frame(x$items))
        data_df <- x$items
    else if (is.list(x$items) && !is.data.frame(x$items))
        data_df <- do.call(rbind, x$items)
    if (!is.null(data_df$permissions.effective)) {
        data_df$permissions.effective <- vapply(data_df$permissions.effective, paste, collapse = ",", FUN.VALUE = character(1))
        names(data_df) <- gsub(".effective", "", names(data_df), fixed = TRUE)
    }
    names(data_df) <- gsub("PropertyId", "propertyId", names(data_df), fixed = TRUE)
    return(data_df)
}

# Build a data.frame for GA report data
#' @include utils.R
build_df <- function(type = c("ga", "mcf", "realtime", "mgmt"), data) {
    type <- match.arg(type)
    data_df <- switch(type,
                      ga = df_ga(data),
                      rt = df_realtime(data),
                      mcf = df_mcf(data),
                      mgmt = df_mgmt(data))
    rownames(data_df) <- NULL
    colnames(data_df) <- to_separated(colnames(data_df), sep = ".")
    data_df <- convert_datatypes(data_df)
    message(paste("Obtained data.frame with", nrow(data_df), "rows and", ncol(data_df), "columns."))
    return(data_df)
}
