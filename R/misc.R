compact <- function(x) {
    Filter(Negate(is.null), x)
}
