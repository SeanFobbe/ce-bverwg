#' Datensatz finalisieren
#'
#' Der BPatG-Datensatz wird mit dieser Funktion um bereits berechnete Variablen angereichert, mit Variablen aus der Download Table verbunden und in Reihenfolge der Variablen-Dokumentation des Codebooks sortiert. Sollten die Anzahl oder die Namen der Variablen von denen im Codebook abweichen wird die Funktion mit einer Fehlermeldung abbrechen.

#' @param x Data.table. Der nach Datum sortierte und im Text bereinigte Datensatz.
#' @param downlod.table Data.table. Die Tabelle mit den Informationen zum Download. Wird mit dem Hauptdatensatz vereinigt.
#' @param aktenzeichen Character. Ein Vektor aus Aktenzeichen.
#' @param ecli Character. Ein Vektor aus ECLIs.
#' @param entscheidung_typ Character. Ein Vektor aus Entscheidungstypen.
#' @param verfahrensart Character. Ein Vektor der jeweiligen Verfahrensarten.
#' @param variablen Character. Die im Datensatz erlaubten Variablen, in der im Codebook vorgegebenen Reihenfolge.




f.dataset_finalize <- function(x,
                               download.table,
                               aktenzeichen,
                               ecli,
                               entscheidung_typ,
                               verfahrensart,
                               lingstats,
                               constants,
                               variablen){



    dt.main <- cbind(x,
                     aktenzeichen,
                     ecli,
                     entscheidung_typ,
                     verfahrensart,
                     lingstats,
                     constants)

    


    

    dt.download.reduced <- download.table[,.(doc_id,
                                             url,
                                             bemerkung,
                                             berichtigung,
                                             wirkung,
                                             ruecknahme,
                                             erledigung)]

    dt.download.reduced$doc_id <- gsub("\\.pdf",
                                       "\\.txt",
                                       dt.download.reduced$doc_id)
    
    
    dt.final <- merge(dt.main,
                      dt.download.reduced,
                      by = "doc_id")

    variablen <- gsub("\\\\", "", variablen)

    
    data.table::setcolorder(dt.final, variablen)


    return(dt.final)


    
}
