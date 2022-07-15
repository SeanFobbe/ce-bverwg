#' Aktenzeichen säubern (BPatG)
#'
#' Ein Vektor von BPAtG-Aktenzeichen aus der amtlichen Datenbank wird gesäubert und als Vektor wieder ausgegeben.

#' @param x Character. Rohe Aktenzeichen aus der BPatG-Datenbank.

#' @return Character. Korrigierte Aktenzeichen im Format [Senat]_[Registerzeichen]_[Eingangsnummer]_[Eingangsjahr]



f.clean_az_bpatg <- function(x){

    ## An dieser Stelle wird eine mysteriöse Unterstrich-Variante mit einem regulären Unterstrich ersetzt. Es ist mir aktuell unklar um was für eine Art von Zeichen es sich handelt und wieso es in den Daten des Bundespatentgerichts auftaucht. Vermutlich handelt es sich um non-breaking spaces.

    az <- sub(" \\(pat\\)", "-pat", x)
    az <- gsub(" ", "_", az)

    ## Weitere Korrekturen
    az <- gsub("\\/", "_", az)
    az <- gsub("\\(|\\)", "", az)
    az <- gsub("W_pat9", "W-pat", az)
    az <- gsub("W_pat", "W-pat", az)
    az <- gsub("30_W-pat103_00", "30_W-pat_103_00", az)
    az <- gsub("15_W-pat16_17", "15_W-pat_16_17", az)
    az <- gsub("([0-9]{2})(E[UP])", "\\1_\\2", az)
    az <- gsub("8_W_(pat)_40/41", "\\1_\\2", az)
    az <- gsub("8_W-pat_40_41", "8_W-pat_40_01", az) # fehlerhaftes Jahr, gemeint ist 2001; Verfahrensgegenstand ist von 2001, Entscheidung von 2002    



    ## Strenge REGEX-Validierung des Aktenzeichens

    regex.test <- grep(paste0("^[0-9]{1,2}", # Senatsnummer
                              "_",
                              "((Ni)|(W-pat)|(ZA-pat)|(Li)|(LiQ))", # Registerzeichen
                              "_",
                              "[0-9]+", # Eingangsnummer
                              "_",
                              "[0-9]{2}"), # Eingangsjahr
                       az,
                       invert = TRUE,
                       value = TRUE)

    
    ## Stoppen falls REGEX-Validierung gescheitert

    if (length(regex.test) != 0){

        warning("Folgende Aktenzeichen sind fehlerhaft:")
        warning(regex.test)
        
        stop("REGEX VALIDIERUNG GESCHEITERT: AKTENZEICHEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }


    return(az)

}
