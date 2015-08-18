.onLoad <- function(libname, pkgname) {
    op <- options()
    op.rga <- list(
        rga.username = NULL,
        rga.client.id = "144394141628-8m5i5icva7akegi3tp6215d9eg9o5cln.apps.googleusercontent.com",
        rga.client.secret = "wlFmhluHqTdZw6UG22h5A2nr",
        rga.cache = ".ga-token.rds",
        rga.token = "GAToken"
    )
    toset <- !(names(op.rga) %in% names(op))
    if (any(toset)) options(op.rga[toset])

    invisible()
}
