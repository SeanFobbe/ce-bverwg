#' Experimentelle Erstellung von ECLIs für Entscheidungen des Bundesverwaltungsgerichts.

#' Experimentell! Erstellt ECLIs für Entscheidungen des Bundesverwaltungsgerichts.
#'
#' Struktur und Inhalt der ECLI für deutsche Gerichte sind auf dem Europäischen Justizportal näher erläutert. \footnote{\url{https://e-justice.europa.eu/content_european_case_law_identifier_ecli-175-de-de.do?member=1}}
#'
#' Sofern die Variablen korrekt extrahiert wurden lässt sich die ECLI vollständig rekonstruieren.


#' @param x Data.table. Ein BVerwG-Datensatz mit den Variablen "datum", "entscheidung_typ", "spruchkoerper_az", "registerzeichen", "eingangsnummer", "eingangsjahr_az", "verzoegerung" und "kollision".
#' @param dt.download.final Data.table. Eine Download-Tabelle mit den Variablen "url" und "doc_id".


#' @param return Ein Vektor mit ECLIs für das Bundesverwaltungsgericht.




f.var_ecli_bverwg <- function(x,
                              dt.download.final,
                              files.pdf){


    ## Ordinalzahl erstellen

    ecli.ordinalzahl <- paste0(format(x$datum,
                                      "%d%m%y"),
                               x$entscheidung_typ,
                               x$spruchkoerper_az,
                               gsub("-",
                                    "",
                                    x$registerzeichen),
                               x$eingangsnummer,
                               ".",
                               formatC(x$eingangsjahr_az,
                                       width = 2,
                                       flag = "0"),
                               ifelse(is.na(x$verzoegerung),
                                      ".",
                                      x$verzoegerung),
                               x$kollision)


    ecli.ordinalzahl <- gsub("NA",
                             "",
                             ecli.ordinalzahl)




    


    ## === ECLI testen ===


    ## --- Tabelle der Soll- und Ist-Ordinalzahlen vorbereiten ---
    ## Die im vorigen Schritt generierten ECLI-Ordinalzahlen ("ist") werden nun noch einmal mit den in den Links angegebenen ECLI-Ordinalzahlen ("soll") gegenübergestellt um sicherzustellen, dass es sich um gültige ECLIs handelt.
    
    ## Berücksichtigt werden im folgenden nur Dateien die tatsächlich heruntergeladen wurden.
    
    eclitest.index <- dt.download.final$doc_id %in% basename(files.pdf)

    eclitest.links <- dt.download.final$url[eclitest.index]
    eclitest.pdf <- dt.download.final$doc_id[eclitest.index]

    soll <- basename(eclitest.links)


    ## Bei einigen PDF-Dateien sind die Soll-Ordinalzahlen (z.B. "010806B1WDS-VR3.06.0" und "130607B1WDS-VR2.07.0") in den Links fehlerhaft, weil Bindestriche im ECLI-System nicht vorgesehen sind. Für diese Dateien werden vor dem Abgleich Korrekturen vorgenommen.

    soll <- gsub("\\.pdf",
                 "",
                 soll)

    soll <- gsub(";",
                 "",
                 soll)

    soll <- gsub("WDS-([VRAVPKH]{1,3})",
                 "WDS\\1",
                 soll)

    soll <- gsub("D-PKH",
                 "DPKH",
                 soll)

    

    ## Bei diesen Entscheidungen sind die Links fehlerhaft.  Die korrekten ECLI-Ordinalzahlen für die beiden Entscheidungen stammen jeweils aus dem Text des PDF-Dokumentes.
    
    soll <- gsub("030206BPKH1.062.06.0",
                 "030206B8PKH1.06.0",
                 soll)
    
    soll <- gsub("190405BVR1011.041012.04.0",
                 "190405B4VR1011.04.0",
                 soll)
    

    ## Tabelle der Soll- und Ist-Ordinalzahlen erstellen

    ist <- ecli.ordinalzahl

    soll <- soll[match(basename(files.pdf),
                       eclitest.pdf)]


    ecli.o.check <- data.table(soll,
                               ist)



    ## ECLI-Test durchführen

    test.result <- identical(ecli.o.check$soll,
                             ecli.o.check$ist)
    

    if (test.result == FALSE){

        diff <- setdiff(ecli.o.check$soll, ecli.o.check$ist)
        fehlerhaft <- ecli.o.check[soll %in% diff]
        
        warning("Folgende ECLIs sind fehlerhaft:")
        warning(fehlerhaft)
        
        stop("REGEX-Test gescheitert. ECLIs sind fehlerhaft.")
    }


    
    ## Vollständige ECLI erstellen
    
    ecli <- paste0("ECLI:DE:BVerwG:",
                   x$entscheidungsjahr,
                   ":",
                   ecli.ordinalzahl)

    
    return(ecli)


}

