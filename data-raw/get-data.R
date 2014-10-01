# Request URL
url <- "https://www.googleapis.com/analytics/v3/metadata/ga/columns"
# Get JSON data
data_json <- jsonlite::fromJSON(url)
# Subsettings
data_r <- .subset2(data_json, "items")
id <- .subset2(data_r, "id")
attributes <- .subset2(data_r, "attributes")
# Convert column types
attributes  <- transform(attributes,
    allowedInSegments = as.logical(match(allowedInSegments, table = c(NA, "true")) - 1),
    minTemplateIndex = as.numeric(minTemplateIndex),
    maxTemplateIndex = as.numeric(maxTemplateIndex),
    premiumMinTemplateIndex = as.numeric(premiumMinTemplateIndex),
    premiumMaxTemplateIndex = as.numeric(premiumMaxTemplateIndex)
)
# Create data.frame
ga <- cbind(id, attributes, stringsAsFactors = FALSE)
# Save dataset
devtools::use_data(ga, internal = TRUE, overwrite = TRUE)
# Resave sysdata.rda with the best compression
tools::resaveRdaFiles(paths = "R/sysdata.rda")
