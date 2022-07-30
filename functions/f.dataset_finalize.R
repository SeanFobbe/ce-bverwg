#' Datensatz finalisieren
#'
#' Der Datensatz wird mit dieser Funktion um bereits berechnete Variablen angereichert und in Reihenfolge der Variablen-Dokumentation des Codebooks sortiert. Sollten die Anzahl oder die Namen der Variablen von denen im Codebook abweichen wird die Funktion mit einer Fehlermeldung abbrechen.

#' @param x Data.table. Der nach Datum sortierte und im Text bereinigte Datensatz.
#' @param vars.additional Data.table. Zusätzliche Variablen, die zuvor extrahiert wurden und nun mit cbind eingehängt werden. Vektoren müssen so geordnet sein wie 'x'.
#' @param varnames Character. Die im Datensatz erlaubten Variablen, in der im Codebook vorgegebenen Reihenfolge.




f.dataset_finalize <- function(x,
                               vars.additional,
                               varnames){


    ## Bind additional vars
    dt.final <- cbind(x,
                     vars.additional)

    ## Remove LaTeX escape characters
    varnames <- gsub("\\\\", "", varnames)

    ## Set column order
    data.table::setcolorder(dt.final, varnames)


    return(dt.final)


    
}
