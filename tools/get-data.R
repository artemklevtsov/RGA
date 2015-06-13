# Get data
ga <- RGA::list_metadata("ga")
# Save dataset
write.csv(ga, file = "data-raw/ga.csv", row.names = FALSE)
devtools::use_data(ga, overwrite = TRUE)
# Resave sysdata.rda with the best compression
tools::resaveRdaFiles(paths = "data/")
