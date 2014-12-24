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
        pv_idx <- grep("MCF_SEQUENCE", cols$dataType, fixed = TRUE, invert = TRUE)
        cv_idx <- grep("MCF_SEQUENCE", cols$dataType, fixed = TRUE)
        primitive <- lapply(data, function(x) .subset2(x, "primitiveValue")[pv_idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- cols$name[pv_idx]
        conversion <- lapply(data, function(x) .subset2(x, "conversionPathValue")[cv_idx])
        conversion <- lapply(conversion, function(i) lapply(i, function(x) paste(apply(x, 1, paste, collapse = ":"), collapse = " > ")))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- cols$name[cv_idx]
        data_df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, cols$name]
    } else {
        data_df <- as.data.frame(do.call(rbind, lapply(data, unlist)), stringsAsFactors = FALSE)
        colnames(data_df) <- cols$name
    }
    return(data_df)
}

# Remove lists from mgmt data
clean_mgmt <- function(data) {
    data_names <- names(data)
    to_drop <- c("kind", grep("Link", data_names, value = TRUE))
    data <- data[, !data_names %in% to_drop]
    if (!is.null(data$permissions.effective)) {
        data$permissions.effective <- vapply(data$permissions.effective, paste, collapse = ",", FUN.VALUE = character(1))
        names(data)[grep("permissions", names(data))] <- "permissions"
    }
    return(data)
}

# Rename list with sublists for mgmt data
#' @include utils.R
rename_mgmt <- function(x) {
    names(x) <-  to_separated(names(x), sep = ".")
    to_rename <- vapply(x, is.list, logical(1))
    x[to_rename] <- lapply(x[to_rename], function(x) setNames(x, to_separated(names(x), sep = ".")))
    names(x) <- gsub("web.property", "webproperty", names(x), fixed = TRUE)
    return(x)
}

# Build data.frame for mgmt data
build_mgmt <- function(data) {
    if (is.data.frame(data))
        data_df <- clean_mgmt(data)
    else if (is.list(data)) {
        data <- lapply(data, clean_mgmt)
        all_names <- lapply(data, names)
        u_names <- unique(unlist(all_names))
        for (i in seq_along(data)) {
            diff_names <- setdiff(u_names, all_names[[i]])
            data[[i]][diff_names] <-  NA
        }
        data_df <- do.call(rbind, data)
    }
    return(data_df)
}

# Build a data.frame for GA report data
#' @include utils.R
build_df <- function(type = c("ga", "mcf", "rt", "mgmt"), data, cols, verbose = getOption("rga.verbose")) {
    if (verbose)
        message("Building data frame...")
    type <- match.arg(type)
    data_df <- switch(type,
                      ga = build_ga(data, cols),
                      rt = build_ga(data, cols),
                      mcf = build_mcf(data, cols),
                      mgmt = build_mgmt(data))
    if (verbose)
        message(paste("Obtained data.frame with", nrow(data_df), "rows and", ncol(data_df), "columns."))
    rownames(data_df) <- NULL
    colnames(data_df) <- to_separated(colnames(data_df), sep = ".")
    colnames(data_df) <- gsub("web.property", "webproperty", colnames(data_df), fixed = TRUE)
    if (verbose)
        message("Converting data types...")
    data_df <- convert_datatypes(data_df)
    return(data_df)
}
