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


    ## Linkliste erstellen

    links.list <- vector("list",
                         length(scope))


    for (i in seq_along(scope)){
        
        URL  <-  paste0("https://www.bverwg.de/suche?q=+*&db=e&dt=&lim=1000&start=",
                        scope[i])
        
        volatile <- f.linkextract(URL)

        links.temp <- grep ("/de/[0-9][0-9][0-9][0-9]",
                            volatile,
                            ignore.case = TRUE,
                            value = TRUE)
        
        links.temp <- gsub(pattern = "/de/",
                           replacement = "",
                           links.temp)
        
        links.temp <- paste0("https://www.bverwg.de/entscheidungen/pdf/",
                             links.temp,
                             ".pdf")
        
        links.temp <- gsub(" ",
                           "",
                           links.temp,
                           fixed = TRUE)

        links.list[[i]] <- links.temp
        
        message(paste(scope[i], "bis", scope[i] + 999))

        Sys.sleep(runif(1, 1, 2))
    }

    ## Liste in Vektor transformieren
    links.pdf <- unlist(links.list)


    ## Auf einzigartige Links reduzieren
    links.pdf <- unique(links.pdf)


    return(links.pdf)

}







