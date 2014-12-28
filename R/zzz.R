.onLoad <- function(libname, pkgname) {
    op <- options()
    op.rga <- list(
        rga.cache = ".ga-token.rds",
        rga.token = "GAToken"
    )
    toset <- !(names(op.rga) %in% names(op))
    if(any(toset)) options(op.rga[toset])

    invisible()
}
