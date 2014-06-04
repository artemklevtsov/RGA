get_report_url <- function(query) {
    stopifnot(inherits(query, "GAQuery"))
    if (inherits(query, "ga"))
        url <- "https://www.googleapis.com/analytics/v3/data/ga"
    else if (inherits(query, "mcf"))
        url <- "https://www.googleapis.com/analytics/v3/data/mcf"
    else
        stop("Unknown report type.")
    query <- as.character(query)
    return(paste(url, query, sep = "?"))
}

build_ga <- function(rows, columns) {
    columns$name <- gsub("ga:", "", columns$name)
    data.df <- as.data.frame(rows, stringsAsFactors = FALSE)
    colnames(data.df) <- columns$name
    return(data.df)
}

build_mcf <- function(rows, columns) {
    columns$name <- gsub("mcf:", "", columns$name)
    if (any(grepl("MCF_SEQUENCE", columns$dataType))) {
        primitive.idx <- grep("MCF_SEQUENCE", columns$dataType, invert = TRUE)
        conversion.idx <- grep("MCF_SEQUENCE", columns$dataType)
        primitive <- lapply(lapply(x$rows, "[[", "primitiveValue"), "[", primitive.idx)
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- columns$name[primitive.idx]
        conversion <- lapply(lapply(x$rows, "[[", "conversionPathValue"), "[", conversion.idx)
        conversion <- lapply(conversion, function(x) lapply(x, function(i) apply(i, 1, paste, sep = "", collapse = ":")))
        conversion <- lapply(conversion, function(x) lapply(x, paste, collapse = " > "))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- columns$name[conversion.idx]
        data.df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, columns$name]
    } else {
        data.df <- as.data.frame(do.call(rbind, lapply(x$rows, unlist)), stringsAsFactors = FALSE)
        # insert column names
        colnames(data.df) <- columns$name
    }
    return(data.df)
}

convert_datatypes <- function(x, formats, date.format = "%Y-%m-%d") {
    formats[formats %in% c("INTEGER", "PERCENT", "TIME", "CURRENCY", "FLOAT")] <- "numeric"
    formats[formats == "STRING"] <- "character"
    formats[formats == "MCF_SEQUENCE"] <- "character"
    x[] <- lapply(seq_along(formats), function(i) as(x[[i]], Class = formats[i]))
    if ("date" %in% colnames(x)) {
        x$date <- format(as.Date(x$date, "%Y%m%d"), date.format)
    }
    if ("conversionDate" %in% colnames(x)) {
        x$conversionDate <- format(as.Date(x$conversionDate, "%Y%m%d"), date.format)
    }
    return(x)
}

get_report <- function(query, token, date.format = "%Y-%m-%d", messages = FALSE) {
    url <- get_report_url(query)
    data.json <- get_api_request(url, token = token, messages = messages)
    rows <- data.json$rows
    columns <- data.json$columnHeaders
    formats <- columns$dataType
    sampled <- data.json$containsSampledData
    if (sampled)
        warning("Data contains sampled data.")
    max.rows <- min(data.json$totalResults, query$max.results)
    total.pages <- ceiling(max.rows / query$max.results)
    if (total.pages > 1L) {
        for (page in 2:total.pages) {
            query$start.index <- query$max.results * (page - 1) + 1
            url <- get_report_url(query)
            data.json <- get_api_request(url, token = token, messages = messages)
            if (inherits(rows, "list"))
                rows <- append(rows, data.json$rows)
            else if (inherits(rows, "matrix"))
                rows <- rbind(rows, data.json$rows)
        }
    }
    if (inherits(query, "ga"))
        data.r <- build_ga(rows, columns)
    else if (inherits(query, "mcf"))
        data.r <- build_mcf(rows, columns)
    data.df <- convert_datatypes(data.r, formats, date.format = date.format)
    return(data.df)
}

get_firstdate <- function(profile.id, token) {
    query <- set_query(profile.id, start.date = "2005-01-01",
                       metrics = "ga:sessions", dimensions = "ga:date",
                       filters = "ga:sessions!=0", max.results = 1L)
    data.r <- get_report(query, token = token)
    return(data.r$date)
}
