#' Diese Funktion nimmt eine ganzzahlige y-Variable als Maximum einer Sequenz von 1 bis y und weist ihr in einer data.table jeweils immer die gleiche x-Variable zu.

#' @param x Integer.
#' @param y Integer.
#'
#' @return Data.table.

f.extend <- function(x, y, begin = 0){
    y.ext <- begin:y
    x.ext <- rep(x, length(y.ext))
    dt.out <- list(data.table(x.ext, y.ext))
    return(dt.out)
}

f.extend <- Vectorize(f.extend)

