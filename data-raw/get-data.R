# Load libraries
library(jsonlite)
# Request URL
url <- "https://www.googleapis.com/analytics/v3/metadata/ga/columns"
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
# Get data file path
data_file <- file.path("R/sysdata.rda")
# Assign new_data according with a data name
assign("ga", new_data)
# Get old data
if (!file.exists(data_file)) {
    # Save data to file
    save(ga, file = data_file, compress = "xz")
} else {
    load(data_file)
    old_data <- get("ga")
    if (!identical(old_data, new_data)) {
        save(ga, file = data_file, compress = "xz")
    }
}
