.onLoad <- function(libname, pkgname) {
    op <- options()
    op.rga <- list(
        rga.verbose = FALSE,
        rga.cache = ".ga-token.rds"
    )
    toset <- !(names(op.rga) %in% names(op))
    if(any(toset)) options(op.rga[toset])

    invisible()
}
