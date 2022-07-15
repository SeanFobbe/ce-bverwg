#' Download-Tabelle finalisieren
#'
#' Stellt die finale Download-Tabelle für das BPatG her. Die ursprüngliche aus der Datenbank extrahierte Tabelle wird mit korrigierten Aktenzeichen und Senatsgruppen angereichert. Zusätzliche Variablen werden aus der Variable "bemerkung" extrahiert. Ein Dateiname wird erstellt und auf Konformität mit dem Codebook geprüft, ansonsten bricht die Funktion mit einer Fehlermeldung ab. 


#' @param x Data.table. Download-Tabelle für das BPatG.
#' @param az Character. Korrigierte Aktenzeichen.
#' @param senatsgruppe Character. Korrigierte Senatsgruppen.


f.download_table_finalize <- function(x,
                                      az,
                                      senatsgruppe){


    ## Korrigierte Variablen einfügen

    x$az <- az
    x$senatsgruppe <- senatsgruppe

    ## Einzelkorrektur

    x[az == "27_W-pat_69_08"]$datum <- as.Date("2008-06-03")

    
    ## Variable "leitsatz" erstellen

    x$leitsatz <- ifelse(grepl("Leitsatz",
                               x$bemerkung,
                               ignore.case = TRUE),
                         "LE",
                         "NA")

    
    ## Variable "berichtigung" erstellen

    x$berichtigung <- ifelse(grepl("berichtigung",
                                   x$bemerkung,
                                   ignore.case = TRUE),
                             TRUE,
                             FALSE)

    ## Variable "wirkung" erstellen

    x$wirkung <- ifelse(grepl("Wirkungslos",
                              x$bemerkung,
                              ignore.case = TRUE),
                        FALSE,
                        TRUE)

    ## Variable "ruecknahme" erstellen

    x$ruecknahme <- ifelse(grepl("zurückgenommen",
                                 x$bemerkung,
                                 ignore.case = TRUE),
                           TRUE,
                           FALSE)

    
    ## Variable "erledigung" erstellen

    x$erledigung <- ifelse(grepl("erledigt|Erledigung",
                                 x$bemerkung,
                                 ignore.case = TRUE),
                           TRUE,
                           FALSE)

    

    
    ## Dateinamen erstellen

    filename <- paste("BPatG",
                      x$senatsgruppe,
                      x$leitsatz,
                      x$datum,
                      x$az,
                      sep = "_")

    ## NA einfügen falls EU/EP flag nicht vorhanden
    filename <- ifelse(grepl("(EU|EP)$",
                             filename),
                       filename,
                       paste0(filename, "_NA"))


    ## Kollisions-IDs vergeben
    filenames1 <- make.unique(filename, sep = "-----")


    indices <- grep("-----",
                    filenames1,
                    invert = TRUE)

    values <- grep("-----",
                   filenames1,
                   invert = TRUE,
                   value = TRUE)

    filenames1[indices] <- paste0(values,
                                  "_0")

    filenames1 <- gsub("-----",
                       "_",
                       filenames1)


    ## PDF-Endung anfügen
    filenames2 <- paste0(filenames1,
                         ".pdf")




    ## Strenge REGEX-Validierung: Gesamter Dateiname
    
    regex.test <- grep(paste0("^BPatG",  # gericht
                              "_",
                              "[A-Za-z-]+", # senatsgruppe
                              "_",
                              "(LE|NA)", # leitsatz 
                              "_",
                              "[0-9]{4}-[0-9]{2}-[0-9]{2}", # datum
                              "_",
                              "[0-9]{1,2}", # senatsnummer
                              "_",
                              "((Ni)|(W-pat)|(ZA-pat)|(Li)|(LiQ))", # registerzeichen
                              "_",
                              "[0-9]+", # eingangsnummer
                              "_",
                              "[0-9]{2}", # Ringangsjahr 
                              "_",
                              "EU|EP|NA", # zusatz_az
                              "_",
                              "[0-9]+"), # kollision
                       filenames2,
                       value = TRUE,
                       invert = TRUE)

    
    ## Ergebnis der REGEX-Validierung
                                        #print(regex.test)


    ## Stoppen falls REGEX-Validierung gescheitert

    if (length(regex.test) != 0){
        warning("Fehlerhafte Dateinamen:")
        warning(regex.test)
        stop("REGEX VALIDIERUNG GESCHEITERT: DATEINAMEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }

    ## Vollen Dateinamen in Download Table einfügen
    x$doc_id <- filenames2


    ## Return
    return(x)
    
    
}
