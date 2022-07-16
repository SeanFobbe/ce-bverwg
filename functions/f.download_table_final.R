#' Finale Download-Tabelle erstellen
#'
#' Wertet die Datenbank des Bundesverwaltungsgerichts aus und erstellt einen Vektor mit URLs zu allen PDF-Dateien.

#' Benötigt Packages:
#' - data.table



#' @param url URLs zu Entscheidungen des BVerwG im PDF-Format.
#' @param filename Dateinamen für Entscheidungen des BVerwG im PDF-Format.
#'
#' @return Eine bereinigte Download-Tabelle für Entscheidungen des BVerwG im PDF-Format.




f.download_table_final <- function(url,
                                   filename,
                                   debug.toggle = FALSE,
                                   debug.files = 500){


    ## Tabelle erstellen
    dt.download <- data.table(url,
                              filename)


    ## Duplikate entfernen
    dt.download <- dt.download[!duplicated(dt.download$filename)]



    ## [Debugging Modus] Reduktion des Download-Umfangs

    if (debug.toggle == TRUE){
        dt.download <- dt.download[sample(.N, debug.files)]
    }


    return(dt.download)

}







