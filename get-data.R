# Load libraries
library(jsonlite)
# Request URL
url <- "https://www.googleapis.com/analytics/v3/metadata/ga/columns"
# Get JSON data
data.json <- fromJSON(url)
# Subsettings
data.r <- .subset2(data.json, "items")
id <- .subset2(data.r, "id")
attrs <- .subset2(data.r, "attributes")
# Create data.frame
ga <- cbind(id, attrs, stringsAsFactors = FALSE)
# Save data to file
save(ga, file = "data/ga.rda")
