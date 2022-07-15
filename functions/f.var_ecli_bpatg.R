#' Experimentelle Erstellung von ECLIs für Entscheidungen des Bundespatentgerichts.

#' Experimentell! Erstellt aus einer Reihe an Variablen ECLIs für Entscheidungen des Bundespatentgerichts. Die Struktur der ECLI des BPatG ist nicht dokumentiert, lautet aber vermutlich wie folgt: "ECLI:DE:BPatG:[entscheidungsjahr_iso]:[entscheidungstag][entscheidungsmonat][entscheidungsjahr][entscheidungstyp][senatsnummer][registerzeichen][eingangsnummer].[eingangsjahr].[kollisionsziffer]". Beispiel: "ECLI:DE:BPatG:2022:200622B28Wpat546.21.0".
#'
#' Achtung: alle ECLIs die sich nur in der Kollisionsziffer unterscheiden sind potentiell fehlerhaft, da mir aktuell keine Möglichkeit bekannt ist, die originale Vergabe der Kollisionsziffer zu reproduzieren. Ebenso können ECLIs mit dem Entscheidungstyp "V" fehlerhaft sein, da mir nicht klar ist, ob das BPatG diesen verwendet.


#' @param x Ein juristischer Datensatz als data.table mit den Variablen "datum", "entscheidungsjahr", "spruchkoerper_az", "registerzeichen", "eingangsnummer", "eingangsjahr_az", "zusatz_az" und "kollision".
#' @param entscheidung_typ Typ der Entscheidung des Bundepatentgerichts.


#' @param return Ein Vektor mit ECLIs für das Bundespatentgericht. 




f.var_ecli_bpatg <- function(x,
                             entscheidung_typ){


    ## ECLI erstellen
    ecli <-  paste0("ECLI:DE:BPatG:",
                    x$entscheidungsjahr,
                    ":",
                    format(x$datum,
                           "%d%m%y"),
                    entscheidung_typ,
                    x$spruchkoerper_az,
                    gsub("-", "", x$registerzeichen),
                    x$eingangsnummer,
                    ".",
                    formatC(x$eingangsjahr_az,
                            width = 2,
                            flag = "0"),
                    ifelse(is.na(x$zusatz_az),
                           "",
                           x$zusatz_az),
                    ".",
                    x$kollision)


    ## ECLI testen
    test.regex <- grep(paste0("ECLI:DE:BPatG:", # Eingangsformel
                              "[0-9]{4}:", # Eingangsjahr (vierstellig)
                              "[0-9]{6}", # Datum
                              "[BU]", # Entscheidungstyp
                              "[0-9]{1,2}", # Senatsnummer
                              "((Ni)|(Wpat)|(ZApat)|(Li)|(LiQ))", # Registerzeichen
                              "[0-9]+\\.", # Eingangsnummer
                              "[0-9]{2}[EPU]{0,2}\\.", # Eingangsjahr (zweistellig) und ggf. Zusatz EP/EU
                              "[0-9]{1,2}"),  # Kollisionsziffer
                       ecli,
                       value = TRUE,
                       invert = TRUE)



    if (length(test.regex) > 0){

        warning("Folgende ECLIs sind fehlerhaft:")
        warning(test.regex)
        
        stop("REGEX-Test gescheitert. ECLIs sind fehlerhaft.")
        }

    return(ecli)


    }
