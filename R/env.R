# The inner package environment
.RGAEnv <- new.env(parent = emptyenv())

.RGAEnv$Token <- NULL
.RGAEnv$Attempt <- 0L
