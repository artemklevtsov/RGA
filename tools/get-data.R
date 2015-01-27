# Get data
ga <- RGA::list_metadata("ga")
# Save dataset
write.csv(ga, file = "data-raw/ga.csv", row.names = FALSE)
devtools::use_data(ga, overwrite = TRUE)
# Resave sysdata.rda with the best compression
for (f in list.files("data/", , full.names = TRUE))
    tools::resaveRdaFiles(paths = f)
