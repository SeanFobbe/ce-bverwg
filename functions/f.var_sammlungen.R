#' f.var_sammlungen
#'
#' Extrahiert aus BVerwG-Entscheidungen Hinweise auf die Veröffentlichung der Entscheidung in einer Sammlung oder ob sie mit Leitsätzen versehen ist.
#'
#' @param text String. Ein Vektor aus Texten von BVerwG-Entscheidungen.
#'
#' @return Data.table. Eine Tabelle mit Variablen für BVerwGE, Übersetzung und Leitsätze. Mit 1 codiert flls enthalten,  sonst mit 0.



 
##' Beispiel:
##'
##'
##' BVerwGE: ja
##' Übersetzung: nein
##'
##' Testing:
##' substr(dt.bverwg.datecleaned[doc_id == "BVerwG_2021-11-25_U_7_C_6_20_NA_0.txt"]$text, 1, 2000)




f.var_sammlungen <- function(text){

    text.sub <- substr(text, 1, 2000)
    
    bverwge <- grepl("BVerwGE: *ja",
                   text.sub,
                   ignore.case = TRUE) * 1

    uebersetzung <- grepl("Übersetzung: *ja",
                   text.sub,
                   ignore.case = TRUE) * 1
        
    leitsatz <- grepl("Leitsätze|Leitsatz",
                  text.sub,
                  ignore.case = TRUE) * 1

    fachpresse <- grepl("Fachpresse: *ja",
                  text.sub,
                  ignore.case = TRUE) * 1


    dt.return <- data.table(bverwge,
                            uebersetzung,
                            leitsatz,
                            fachpresse)

    return(dt.return)

}
