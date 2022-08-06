#' Dateinamen erstellen (BVerwG)
#'
#' Erstellt aus den URLs zu den PDF-Dateien semantische Dateinamen für Entscheidungen des Bundesverwaltungsgerichts.
#'
#' @param url Character. Ein Vektor an URLs für Entscheidungen des Bundesverwaltungsgerichts im PDF-Format.
#'
#' @return Character. Ein Vektor mit semantischen Dateinamen.



f.filenames.bverwg <- function(url){



    ## === Extrahieren der ECLI-Ordinalzahl ===
    ## Die Links zu jeder Entscheidung enthalten das Ordinalzahl-Element ihres jeweiligen ECLI-Codes. Struktur und Inhalt der ECLI für deutsche Gerichte sind auf dem Europäischen Justizportal näher erläutert. \footnote{\url{https://e-justice.europa.eu/content_european_case_law_identifier_ecli-175-de-de.do?member=1}}


    filenames <- basename(url)

    filenames <- gsub(".pdf",
                      "",
                      filenames)

    filenames <- gsub("\\;",
                      "",
                      filenames)

    filenames <- gsub("\\-",
                      "",
                      filenames)


    ## === Einzelkorrekturen vornehmen ===
    ## Soweit ich erkennen kann, handelt es sich bei dem "S" in der Ordinalzahl "280814U2WD20.13S.0" um einen Fehler im Link. Jedenfalls taucht das S nirgendwo in der Dokumentation der ECLI-Strukturen oder dem Volltext des Urteils selber auf.
    
    filenames <- gsub("280814U2WD20.13S.0",
                      "280814U2WD20.13.0",
                      filenames)


    ## Bei den folgenden Entscheidungen sind die Links fehlerhaft. Die korrekten ECLI-Ordinalzahlen für die beiden Entscheidungen stammen jeweils aus dem Text des PDF-Dokumentes.

    filenames <- gsub("030206BPKH1.062.06.0",
                      "030206B8PKH1.06.0",
                      filenames)

    filenames <- gsub("190405BVR1011.041012.04.0",
                      "190405B4VR1011.04.0",
                      filenames)



    ## Transformation zu Variablen mit Unterstrichen

    filenames1 <- gsub("([0-9]{2})([0-9]{2})([0-9]{2})([A-Z])([0-9]{1,2})([A-Za-z\\-]*)([0-9]*)[\\.]([0-9]*)([D\\.])",
                       "BVerwG_\\3-\\2-\\1_\\4_\\5_\\6_\\7_\\8_\\9_",
                       filenames)



    filenames1 <- gsub("020320BGrSen1.19.0",
                       "BVerwG_20-03-02_B_NA_GrSen_1_19_NA_0",
                       filenames1)



    ## Punkt zu NA

    filenames1 <- gsub("\\.",
                       "NA",
                       filenames1)




    ## Registerzeichen mit Bindestrichen anpassen


    filenames1 <- gsub("WDSKSt",
                       "WDS-KSt",
                       filenames1)

    filenames1 <- gsub("WDSVR",
                       "WDS-VR",
                       filenames1)

    filenames1 <- gsub("WDSPKH",
                       "WDS-PKH",
                       filenames1)

    filenames1 <- gsub("WDSAV",
                       "WDS-AV",
                       filenames1)


    filenames1 <- gsub("DPKH",
                       "D-PKH",
                       filenames1)




    ## Entscheidungsdatum in ISO-Format transformieren


    variable.split <- tstrsplit(filenames1,
                                split = "_")
    setDT(variable.split)


    date.split <- tstrsplit(variable.split$V2,
                            split = "-")
    setDT(date.split)


    date.split[, V1 := list(lapply(V1, function(x)f.year.iso(as.numeric(x))))]

    date.combine <- paste(date.split$V1,
                          date.split$V2,
                          date.split$V3,
                          sep = "-")

    variable.combine <- variable.split
    variable.combine$V2 <- date.combine



    ## Dateinamen finalisieren

    filenames.final <- apply(variable.combine,
                             1,
                             function(x)paste(x, collapse = "_"))


    filenames.final <- paste0(filenames.final,
                              ".pdf")

    


    ## REGEX-Validierung: Gesamter Dateiname
    
    regex.test <- grep(paste0("^BVerwG", # Gericht
                              "_",
                              "[0-9]{4}-[0-9]{2}-[0-9]{2}", # Datum
                              "_",
                              "[UBG]", # Entscheidungstyp
                              "_",
                              "[0-9NA]+", # Spruchkörper
                              "_",
                              "[A-Za-z-]+", # Registerzeichen
                              "_",
                              "[0-9]+", # Eingangsnummer
                              "_",
                              "[0-9]{1,2}", # Eingangsjahr
                              "_",
                              "[NAD]+", # Zusatz
                              "_",
                              "[0-9]", # Kollision
                              "\\.pdf$"), # Dateiendung
                       filenames.final,
                       value = TRUE,
                       invert = TRUE)


    ## Fehlerhafte Dateinamen

    if(length(regex.test) != 0){
        warning("Fehlerhafte Dateinamen:")
        warning(regex.test)
    }

    ## Unit Test
    test_that("Dateinamen entsprechen dem Schema im Codebook.", {
        expect_type(filenames.final, "character")
        expect_length(regex.test,  0)
        expect_length(filenames.final, length(url))
    })


    ## Return
    return(filenames.final)
    
    
}
