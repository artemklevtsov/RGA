# Load libraries
library(jsonlite)
# Type of data
data <- "ga"
# Request URL
url <- paste("https://www.googleapis.com/analytics/v3/metadata", data, "columns", sep = "/")
# Get JSON data
data.json <- fromJSON(url)
# Subsettings
data.r <- .subset2(data.json, "items")
id <- .subset2(data.r, "id")
attributes <- .subset2(data.r, "attributes")
attributes  <- transform(attributes,
    allowedInSegments = as.logical(match(allowedInSegments, table = c(NA, "true")) - 1),
    minTemplateIndex = as.numeric(minTemplateIndex),
    maxTemplateIndex = as.numeric(maxTemplateIndex),
    premiumMinTemplateIndex = as.numeric(premiumMinTemplateIndex),
    premiumMaxTemplateIndex = as.numeric(premiumMaxTemplateIndex)
)
# Create data.frame
new_data <- cbind(id, attributes, stringsAsFactors = FALSE)
# Get old data
old_data <- get(data, envir = asNamespace("RGA"))
if (!identical(old_data, new_data)) {
    # Get data file path
    data_file <- file.path("data", paste0(data, ".rda"))
    # Assign new_data according with a data name
    assign(data, new_data)
    # Save data to file
    save(data, file = data_file, compress = "xz")
}
