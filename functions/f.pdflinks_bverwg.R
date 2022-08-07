#' URLs zu PDF-Entscheidungen des BVerwG abrufen
#'
#' Wertet die Datenbank des Bundesverwaltungsgerichts aus und erstellt einen Vektor mit URLs zu allen PDF-Dateien.

#' Benötigt Packages:
#' - rvest



#' @param download.max Die maximale Anzahl URLs, die abgerufen werden soll.
#'
#' @return Ein Vektor von URLs zu allen Entscheidungen des BVerwG im PDF-Format.




f.pdflinks_bverwg <- function(download.max){


    ## Umfang definieren
    scope <- seq(from = 1,
                 to = download.max,
                 by = 1000)




    links.list <- vector("list",
                         length(scope))

    ## Datenbank abrufen
    
    for (i in seq_along(scope)){
        
        URL  <-  paste0("https://www.bverwg.de/suche?q=+*&db=e&dt=&lim=1000&start=",
                        scope[i])
        
        volatile <- f.linkextract(URL)

        links.list[[i]] <- volatile
        
        message(paste(scope[i], "bis", scope[i] + 999))

        Sys.sleep(runif(1, 1, 2))
    }

    ## Liste in Vektor transformieren
    links.all <- unlist(links.list)

    ## Links zu Entscheidungen extrahieren
    links.relative <- grep ("/de/[0-9][0-9][0-9][0-9]",
                            links.all,
                            ignore.case = TRUE,
                            value = TRUE)

    ## Entfernen von /de/
    links.relative <- gsub(pattern = "/de/",
                           replacement = "",
                           links.relative)

    ## Herstellen von PDF Links
    links.pdf <- paste0("https://www.bverwg.de/entscheidungen/pdf/",
                        links.relative,
                        ".pdf")
    ## Whitespace trimmen
    links.pdf <- gsub(" ",
                      "",
                      links.pdf)

    ## Auf einzigartige Links reduzieren
    links.pdf <- unique(links.pdf)
    

    ## REGEX-Validierung: Gesamter Link
    
    regex.test <- grep(paste0("^https://www.bverwg.de/entscheidungen/pdf/",
                              "[0-9A-Za-z\\.\\;-]{8,}", # Minimale Länge des Dateinamens
                              "\\.pdf$"
                              ),
                       links.pdf,
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

    


    return(links.pdf)

}







