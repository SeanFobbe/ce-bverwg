#' Aktenzeichen für deutsche Bundesgerichte erstellen
#'
#' Erstellt ein Aktenzeichen aus den üblichen Bestandteilen für deutsche Bundesgerichte (Spruchkörper, Registerzeichen, Eingangsnummer und zweistelliges Eingangsjahr). Nicht anwendbar in Sonderfällen wie dem Bundespatentgericht.

#' @param x Ein juristischer Datensatz als data.table mit den Variablen "spruchkoerper_az", "registerzeichen", "eingangsnummer", "eingangsjahr_az".

#' @param az.brd Ein data.frame oder data.table mit dem Datensatz "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564."

#' @param gericht Das Gericht, dessen Aktenzeichen zu erstellen sind.


#' @param return Ein Vektor mit Aktenzeichen.




f.var_aktenzeichen <- function(x,
                               az.brd,
                               gericht){


    ## Datensatz auf relevante Daten reduzieren
    az.gericht <- az.brd[stelle == gericht & position == "hauptzeichen"]

    
    ## Variable "aktenzeichen" erstellen

    aktenzeichen <- paste0(x$spruchkoerper_az,
                           " ",
                           mgsub(x$registerzeichen,
                                 az.gericht$zeichen_code,
                                 az.gericht$zeichen_original),
                           " ",
                           x$eingangsnummer,
                           "/",
                           x$eingangsjahr_az)

    
    ## evtl für andere gerichte nützlich
    ## aktenzeichen <- gsub("NA ",
    ##                      "",
    ##                      aktenzeichen)

    return(aktenzeichen)    
    
}
