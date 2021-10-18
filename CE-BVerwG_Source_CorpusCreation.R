#'---
#'title: "Compilation Report | Corpus der Entscheidungen des Bundesverwaltungsgerichts (CE-BVerwG-Source)"
#'author: Seán Fobbe
#'papersize: a4
#'geometry: margin=3cm
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CE-BVerwG_Source_TEX_Definitions.tex,CE-BVerwG_Source_TEX_CompilationTitle.tex]
#'bibliography: packages.bib
#'nocite: '@*'
#' ---



#+ echo = FALSE 
knitr::opts_chunk$set(echo = TRUE,
                      warning = TRUE,
                      message = TRUE)



#'\newpage
#+
#'# Einleitung
#'
#+
#'## Überblick
#' Dieses R-Skript lädt alle auf https://www.bverwg.de/ veröffentlichten Entscheidungen des Bundesverwaltungsgerichts (BVerwG) herunter und kompiliert sie in einen reichhaltigen menschen- und maschinenlesbaren Korpus. Es ist die Basis für den \textbf{\datatitle\ (\datashort )}.
#'
#' Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Jede Version ist mit ihrem eigenen, persistenten Digital Object Identifier (DOI) versehen. Die neueste Version des Datensatzes ist immer über den Link der Concept DOI erreichbar: \url{\dataconcepturldoi}

#+
#'## Funktionsweise

#' Primäre Endprodukte des Skripts sind folgende ZIP-Archive:
#' 
#' \begin{enumerate}
#' \item Der volle Datensatz im CSV-Format
#' \item Die reinen Metadaten im CSV-Format (wie unter 1, nur ohne Entscheidungstexte)
#' \item Alle Entscheidungen im TXT-Format (reduzierter Umfang an Metadaten)
#' \item Alle Entscheidungen im PDF-Format (reduzierter Umfang an Metadaten)
#' \item Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)
#' \item Der Source Code und alle weiteren Quelldaten
#' \end{enumerate}
#'
#' Zusätzlich werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. Weiterhin kann optional ein PDF-Bericht erstellt werden (siehe unter "Kompilierung"). 


#+
#'## Systemanforderungen
#' Das Skript in seiner veröffentlichten Form kann nur unter Linux ausgeführt werden, da es Linux-spezifische Optimierungen (z.B. Fork Cluster) und Shell-Kommandos (z.B. OpenSSL) nutzt. Das Skript wurde unter Fedora Linux entwickelt und getestet. Die zur Kompilierung benutzte Version entnehmen Sie bitte dem **sessionInfo()**-Ausdruck am Ende dieses Berichts.
#'
#' In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Wenn die Anzahl Threads (Variable "fullCores") auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.
#'
#' Auf der Festplatte sollten 6 GB Speicherplatz vorhanden sein.
#' 
#' Um die PDF-Berichte kompilieren zu können benötigen Sie das R package **rmarkdown**, eine vollständige Installation von \LaTeX\ und alle in der Präambel-TEX-Datei angegebenen \LaTeX\ Packages.




#+
#'## Kompilierung

#' Mit der Funktion **render()** von **rmarkdown** können der **vollständige Datensatz** und das **Codebook** kompiliert und die Skripte mitsamt ihrer Rechenergebnisse in ein gut lesbares PDF-Format überführt werden.
#'
#' Alle Kommentare sind im roxygen2-Stil gehalten. Die beiden Skripte können daher auch **ohne render()** regulär als R-Skripte ausgeführt werden. Es wird in diesem Fall kein PDF-Bericht erstellt und Diagramme werden nicht abgespeichert.

#+
#'### Datensatz 

#' 
#' Um den **vollständigen Datensatz** zu kompilieren und einen **PDF-Bericht** zu erstellen, kopieren Sie bitte alle im Source-Archiv bereitgestellten Dateien in einen leeren Ordner und führen mit R diesen Befehl aus:

#+ eval = FALSE

rmarkdown::render(input = "CE-BVerwG_Source_CorpusCreation.R",
                  output_file = paste0("CE-BVerwG_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"),
                  envir = new.env())


#'### Codebook
#' Um das **Codebook** zu kompilieren und einen PDF-Bericht zu erstellen, führen Sie bitte im Anschluss an die Kompilierung des Datensatzes (!) untenstehenden Befehl mit R aus.
#'
#' Bei der Prüfung der GPG-Signatur wird ein Fehler auftreten und im Codebook dokumentiert, weil die Daten nicht mit meiner Original-Signatur versehen sind. Dieser Fehler hat jedoch keine Auswirkungen auf die Funktionalität und hindert die Kompilierung nicht.

#+ eval = FALSE

rmarkdown::render(input = "CE-BVerwG_Source_CodebookCreation.R",
                  output_file = paste0("CE-BVerwG_",
                                       Sys.Date(),
                                       "_Codebook.pdf"),
                  envir = new.env())




#'\newpage
#+
#'# Parameter

#+
#'## Name des Datensatzes
datasetname <- "CE-BVerwG"

#'## DOI des Datensatz-Konzeptes
doi.concept <- "10.5281/zenodo.3911067" # checked

#'## DOI der konkreten Version
doi.version <- "???"

#'## Lizenz
license <- "Creative Commons Zero 1.0 Universal"



#'## Verzeichnis für Analyse-Ergebnisse
#' **Hinweis:** Muss mit einem Schrägstrich enden!
outputdir <- paste0(getwd(),
                    "/ANALYSE/") 



#'## Download-Umfang definieren
scope <- seq(from = 1,
             to = 26000,
             by = 1000)



#'## Modus: Debugging
#' Der Debuging-Modus reduziert den Download-Umfang auf den in der Variable "debug.sample" definierten Umfang zufällig ausgewählter Entscheidungen und löscht im Anschluss fünf zufällig ausgewählte Entscheidungen um den Wiederholungsversuch zu testen. Nur für Test- und Demonstrationszwecke. 

mode.debug <- TRUE
debug.sample <- 100


#'## Modus: Linguistische Annotationen
#' Wenn dieser Modus aktiviert ist wird  mittels spacyr eine zusätzliche Variante des Datensatzes mit umfangreichen linguistischen Annotationen berechnet. Dieser Modus ist sehr rechenintensiv! Kann mit anderen Modi kombiniert werden.

mode.annotate <- TRUE



#'## Optionen: Quanteda
tokens_locale <- "de_DE"



#'## Optionen: Knitr

#+
#'### Ausgabe-Format
dev <- c("pdf",
         "png")


#'### DPI für Raster-Grafiken
dpi <- 300


#'### Ausrichtung von Grafiken im Compilation Report
fig.align <- "center"




#'## Frequenztabellen: Ignorierte Variablen

#' Diese Variablen werden bei der Erstellung der Frequenztabellen nicht berücksichtigt.

varremove <- c("text",
               "eingangsnummer",
               "datum",
               "doc_id",
               "ecli",
               "aktenzeichen")



#'# Vorbereitung

#'## Datumsstempel
#' Dieser Datumsstempel wird in alle Dateinamen eingefügt. Er wird am Anfang des Skripts gesetzt, für den Fall, dass die Laufzeit die Datumsbarriere durchbricht.
datestamp <- Sys.Date()
print(datestamp)


#'## Datum und Uhrzeit (Beginn)
begin.script <- Sys.time()
print(begin.script)


#'## Ordner für Analyse-Ergebnisse erstellen
dir.create(outputdir)


#'## Quellennachweis für Diagramme erstellen

figure.caption <- paste("DOI:",
                        doi.version,
                        "| Fobbe")

print(figure.caption)



#+
#'## Packages Laden

library(httr)         # HTTP-Werkzeuge
library(rvest)        # HTML/XML-Extraktion
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Kable Tabellen
library(pdftools)     # Verarbeitung von PDF-Dateien
library(doParallel)   # Parallelisierung
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung
library(readtext)     # TXT-Dateien einlesen
library(quanteda)     # Fortgeschrittene Computerlinguistik
library(spacyr)       # Linguistische Annotationen


#'## Zusätzliche Funktionen einlesen
#' **Hinweis:** Die hieraus verwendeten Funktionen werden jeweils vor der ersten Benutzung in vollem Umfang angezeigt um den Lesefluss zu verbessern.

source("R-fobbe-proto-package/f.linkextract.R")
source("R-fobbe-proto-package/f.year.iso.R")
source("R-fobbe-proto-package/f.dopar.pdfextract.R")
source("R-fobbe-proto-package/f.hyphen.remove.R")
source("R-fobbe-proto-package/f.fast.freqtable.R")
source("R-fobbe-proto-package/f.lingsummarize.iterator.R")
source("R-fobbe-proto-package/f.dopar.multihashes.R")
source("R-fobbe-proto-package/f.dopar.spacyparse.R")

#'## Quanteda-Optionen setzen
quanteda_options(tokens_locale = tokens_locale)


#'## Knitr Optionen setzen
knitr::opts_chunk$set(fig.path = outputdir,
                      dev = dev,
                      dpi = dpi,
                      fig.align = fig.align)



#'## Vollzitate statistischer Software
knitr::write_bib(c(.packages()),
                 "packages.bib")




#'## Parallelisierung aktivieren
#' Parallelisierung wird zur Beschleunigung der Konvertierung von PDF zu TXT und der Datenanalyse mittels **quanteda** und **data.table** verwendet. Die Anzahl threads wird automatisch auf das verfügbare Maximum des Systems gesetzt, kann aber auch nach Belieben auf das eigene System angepasst werden. Die Parallelisierung kann deaktiviert werden, indem die Variable **fullCores** auf 1 gesetzt wird.
#'
#' Der Download der Dateien ist bewusst nicht parallelisiert, damit das Skript nicht versehentlich als DoS-Tool verwendet wird.
#'
#' Die hier verwendete Funktion **makeForkCluster()** ist viel schneller als die Alternativen, funktioniert aber nur auf Unix-basierten Systemen (Linux, MacOS).


#+
#'### Logische Kerne

fullCores <- detectCores()
print(fullCores)

#'### Quanteda
quanteda_options(threads = fullCores) 

#+
#'### Data.table
setDTthreads(threads = fullCores)  











#'# Download: Weitere Datensätze

#+
#'## Registerzeichen und Verfahrensarten
#' 
#'Die Registerzeichen werden im Laufe des Skripts mit ihren detaillierten Bedeutungen aus dem folgenden Datensatz abgeglichen: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564." Das Ergebnis des Abgleichs wird in die Variable "verfahrensart" in den Datensatz eingefügt.

if (file.exists("AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv") == FALSE){
    download.file("https://zenodo.org/record/4569564/files/AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv?download=1",
 "AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv")
    }



#'## Personendaten zu Präsident:innen
#'
#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.


if (file.exists("PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv") == FALSE){
    download.file("https://zenodo.org/record/4568682/files/PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv?download=1",
                  "PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv")
}




#'## Personendaten zu Vize-Präsident:innen
#' 
#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.


if (file.exists("PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv") == FALSE){
    download.file("https://zenodo.org/record/4568682/files/PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv?download=1",
                  "PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv")
}




#'# Download: Alle Entscheidungen des BVerwG

#+
#'## Funktion zeigen

print(f.linkextract)


#'## Linkliste erstellen

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
    
    links.temp <- gsub(pattern="/de/",
                  replacement="",
                  links.temp)
    
    links.temp <- paste0("https://www.bverwg.de/entscheidungen/pdf/",
                    links.temp,
                    ".pdf")
    
    links.temp <- gsub(" ",
                  "",
                  links.temp,
                  fixed=TRUE)

    links.list[[i]] <- links.temp
    
    print(paste(scope[i], "bis", scope[i] + 999))

    Sys.sleep(runif(1, 1, 2))
}


links.pdf <- unlist(links.list)



#'## Anzahl Links
length(links.pdf)

#'## Anzahl einzigartiger Links
uniqueN(links.pdf)

#'## Vektor auf einzigartige Links reduzieren
links.pdf <- unique(links.pdf)



#'## Dateinamen erstellen

#'### Extrahieren der ECLI-Ordinalzahl
#' Die Links zu jeder Entscheidung enthalten das Ordinalzahl-Element ihres jeweiligen ECLI-Codes. Struktur und Inhalt der ECLI für deutsche Gerichte sind auf dem Europäischen Justizportal näher erläutert. \footnote{\url{https://e-justice.europa.eu/content_european_case_law_identifier_ecli-175-de-de.do?member=1}}


filenames <- basename(links.pdf)

filenames <- gsub(".pdf",
                  "",
                  filenames)

filenames <- gsub("\\;",
                  "",
                  filenames)

filenames <- gsub("\\-",
                  "",
                  filenames)


#'### Einzelkorrekturen vornehmen
#' Soweit ich erkennen kann, handelt es sich bei dem "S" in der Ordinalzahl "280814U2WD20.13S.0" um einen Fehler im Link. Jedenfalls taucht das S nirgendwo in der Dokumentation der ECLI-Strukturen oder dem Volltext des Urteils selber auf.

filenames <- gsub("280814U2WD20.13S.0",
                  "280814U2WD20.13.0",
                  filenames)


#' Bei den folgenden Entscheidungen sind die Links fehlerhaft. Die korrekten ECLI-Ordinalzahlen für die beiden Entscheidungen stammen jeweils aus dem Text des PDF-Dokumentes.

filenames <- gsub("030206BPKH1.062.06.0",
                  "030206B8PKH1.06.0",
                  filenames)

filenames <- gsub("190405BVR1011.041012.04.0",
                  "190405B4VR1011.04.0",
                  filenames)



#'### Transformation zu Variablen mit Unterstrichen

filenames1 <- gsub("([0-9]{2})([0-9]{2})([0-9]{2})([A-Z])([0-9]{1,2})([A-Za-z\\-]*)([0-9]*)[\\.]([0-9]*)([D\\.])",
                   "BVerwG_\\3-\\2-\\1_\\4_\\5_\\6_\\7_\\8_\\9_",
                   filenames)



filenames1 <- gsub("020320BGrSen1.19.0",
                   "BVerwG_20-03-02_B_NA_GrSen_1_19_NA_0",
                   filenames1)



#'### Punkt zu NA

filenames1 <- gsub("\\.",
                   "NA",
                   filenames1)




#'## Registerzeichen mit Bindestrichen anpassen


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




#'## Entscheidungsdatum in ISO-Format transformieren


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



#'## Dateinamen finalisieren

filenames.final <- apply(variable.combine,
                    1,
                    function(x)paste(x, collapse = "_"))


filenames.final <- paste0(filenames.final,
                          ".pdf")





#'## Strenge REGEX-Validierung der Dateinamen



#+
#'### REGEX-Validierung durchführen

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



#'### Ergebnis der REGEX-Validierung
#' **Hinweis:** Das Ergebnis bei Erfolg sollte ein leerer Vektor sein!

print(regex.test)


#'### Skript stoppen falls REGEX-Validierung gescheitert

if (length(regex.test) != 0){
    stop("REGEX VALIDIERUNG GESCHEITERT: DATEINAMEN ENTSPRECHEN NICHT DEM CODEBOOK-SCHEMA!")
    }




#'## Data Table für Download erstellen

dt.download <- data.table(links.pdf,
                          filenames.final)




#'## Duplikate bereinigen

#+
#'### Test auf Duplikate

sort(dt.download$filenames.final[duplicated(dt.download$filenames.final)])


#'### Von Duplikaten betroffene Links
#' Alle diese Links wurden manuell überprüft und es handelt sich tatsächlich um Duplikate. Bei den Entscheidungen mit dem Registerzeichen WDS-VR finden sich Links mit und ohne Trennstrich, beide verweisen aber auf die gleichen Dateien. Die Entscheidungen mit den Ordinalzahlen \enquote{280814U2WD20.13.0.pdf} und \enquote{280814U2WD20.13S.0.pdf} sind identisch, das \enquote{S} nach der 13 ist vermutlich ein Tippfehler, siehe auch weiter oben bei der Einzelkorrektur.

sort(dt.download$links.pdf[duplicated(dt.download$filenames.final,
                                      fromLast = FALSE)])

sort(dt.download$links.pdf[duplicated(dt.download$filenames.final,
                                      fromLast = TRUE)])


#'### Duplikate entfernen

dt.download <- dt.download[!duplicated(dt.download$filenames.final)]







#'## [Debugging Modus] Reduktion des Download-Umfangs

print(mode.debug)

if (mode.debug == TRUE){
    dt.download <- dt.download[sample(.N, debug.sample)]
    }



#'## Zeitstempel: Download Beginn

begin.download <- Sys.time()
print(begin.download)



#'## Download durchführen

for (i in sample(dt.download[,.N])){
    
        tryCatch({download.file(dt.download$links.pdf[i],
                                dt.download$filenames.final[i])
        },
        error = function(cond) {
            return(NA)}
        )
    
    Sys.sleep(runif(1, 0.3, 1))
    
}



#'## Zeitstempel: Download Ende

end.download <- Sys.time()
print(end.download)


#'## Dauer: Download 
end.download - begin.download



#'## [Debugging Modus] Löschen zufälliger Dateien
#' Dient dazu den Wiederholungsversuch zu testen.

print(mode.debug)

if (mode.debug == TRUE){
    files.pdf <- list.files(pattern = "\\.pdf")
    unlink(sample(files.pdf, 5))
    }



#'## Download-Ergebnis

#+
#'### Anzahl herunterzuladender Dateien
dt.download[,.N]

#'### Anzahl heruntergeladener Dateien
files.pdf <- list.files(pattern = "\\.pdf")
length(files.pdf)

#'### Fehlbetrag
missing.N <- dt.download[,.N] - length(files.pdf)
print(missing.N)

#'### Fehlende Dateien
missing.names <- setdiff(dt.download$filenames.final,
                         files.pdf)
print(missing.names)







#'## Wiederholungsversuch: Download
#' Download für fehlende Dokumente wiederholen.

if(missing.N > 0){

    dt.retry <- dt.download[filenames.final %in% missing.names]
    
    for (i in 1:dt.retry[,.N]){
        
        response <- GET(dt.retry$links.pdf[i])
        
        Sys.sleep(runif(1, 1, 3))
        
        if (grepl("application/pdf", response$headers$"content-type") == TRUE  & response$status_code == 200){
            tryCatch({download.file(url = dt.retry$links.pdf[i],
                                    destfile = dt.retry$filenames.final[i])
            },
            error = function(cond) {
                return(NA)}
            )
            
        }else{
            print(paste0(dt.retry$filenames1[i], " : kein PDF vorhanden"))  
        }
        Sys.sleep(runif(1, 2, 5))
    } 
}



#'## Schlussbemerkung
#' Für die verbleibenden zwei Dateien waren auch nach manueller Überprüfung keine PDF-Datei auffindbar. Diese werden vorerst nicht in den Datensatz aufgenommen.


#+
#'## Download: Gesamtergebnis

#+
#'### Anzahl herunterzuladender Dateien
dt.download[,.N]

#'### Anzahl heruntergeladener Dateien
files.pdf <- list.files(pattern = "\\.pdf")
length(files.pdf)

#'### Fehlbetrag
missing.N <- dt.download[,.N] - length(files.pdf)
print(missing.N)

#'### Fehlende Dateien
missing.names <- setdiff(dt.download$filenames.final,
                   files.pdf)
print(missing.names)






#+
#'# Text-Extraktion

#+
#'## Vektor der zu extrahierenden Dateien erstellen

files.pdf <- list.files(pattern = "\\.pdf$",
                        ignore.case = TRUE)


#'## Anzahl zu extrahierender Dateien
length(files.pdf)

#'## Keine Seitenzählung
#' Normalerweise würde an dieser Stelle eine Zählung der PDF-Seiten vorgenommen werden, diese führt aber zu Fehlermeldungen, weil die tatsächliche Anzahl Seiten von der Anzahl Seiten in den Metadaten bei vielen Dateien abweicht.


#+
#'## PDF extrahieren: Funktion anzeigen
#+ results = "asis"
print(f.dopar.pdfextract)


#'## Text Extrahieren
result <- f.dopar.pdfextract(files.pdf,
                             threads = fullCores)




#'# Korpus Erstellen

#+
#'## TXT-Dateien Einlesen

txt.bverwg <- readtext("./*.txt",
                    docvarsfrom = "filenames", 
                    docvarnames = c("gericht",
                                    "datum",
                                    "entscheidung_typ",
                                    "spruchkoerper_az",
                                    "registerzeichen",
                                    "eingangsnummer",
                                    "eingangsjahr_az",
                                    "verzoegerung",
                                    "kollision"),
                    dvsep = "_", 
                    encoding = "UTF-8")


#'## In Data Table umwandeln
setDT(txt.bverwg)




#'## Durch Zeilenumbruch getrennte Wörter zusammenfügen
#' Durch Zeilenumbrüche getrennte Wörter stellen bei aus PDF-Dateien gewonnene Text-Korpora ein erhebliches Problem dar. Wörter werden dadurch in zwei sinnentleerte Tokens getrennt, statt ein einzelnes und sinnvolles Token zu bilden. Dieser Schritt entfernt die Bindestriche, den Zeilenumbruch und ggf. dazwischenliegende Leerzeichen.

#+
#'### Funktion anzeigen
print(f.hyphen.remove)


#'### Funktion ausführen
txt.bverwg[, text := lapply(.(text), f.hyphen.remove)]


#'## Variable "datum" als Datentyp "IDate" kennzeichnen
txt.bverwg$datum <- as.IDate(txt.bverwg$datum)

#'## Variable "entscheidungsjahr" hinzufügen
txt.bverwg$entscheidungsjahr <- year(txt.bverwg$datum)


#'## Variable "eingangsjahr_iso" hinzufügen
txt.bverwg$eingangsjahr_iso <- f.year.iso(txt.bverwg$eingangsjahr_az)




#'## Datensatz nach Datum sortieren
#' Aufgrund der Position der Datums-Variable ist der Datensatz vermutlich schon von Linux nach Datum sortiert worden. Die Erstellung der Variablen für Präsidenten und Vize-Präsidenten trifft allerdings die starke Annahme, dass eine aufsteigende Sortierung nach Datum besteht. Wäre das nicht der Fall, würden dort Fehler auftreten. Diese Sortierung ist als fail-safe gedacht.

setorder(txt.bverwg,
         datum)






#'## Variable "praesi" hinzufügen
#' Diese Variable dokumentiert für jede Entscheidung welche/r Präsident:in am Tag der Entscheidung im Amt war.
#'
#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.



#+
#'### Personaldaten einlesen

praesi <- fread("PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv")
praesi <- praesi[court == "BVerwG", c(1:3, 5:6)]

#'### Personaldaten anzeigen

kable(praesi,
      format = "latex",
      align = "r",
      booktabs = TRUE,
      longtable = TRUE) %>% kable_styling(latex_options = "repeat_header")



#'### Hypothethisches Amtsende für Präsident:in
#' Weil der/die aktuelle Präsident:in noch im Amt ist, ist der Wert für das Amtsende "NA". Dieser ist aber für die verwendete Logik nicht greifbar, weshalb an dieser Stelle ein hypothetisches Amtsende in einem Jahr ab dem Tag der Datensatzerstellung fingiert wird. Es wird nur an dieser Stelle verwendet und danach verworfen.

praesi[is.na(term_end_date)]$term_end_date <- Sys.Date() + 365


#'### Schleife vorbereiten

N <- praesi[,.N]

praesi.list <- vector("list", N)


#'### Vektor erstellen

for (i in seq_len(N)){
    praesi.N <- txt.bverwg[datum >= praesi$term_begin_date[i] & datum <= praesi$term_end_date[i], .N]
    praesi.list[[i]] <- rep(praesi$name_last[i],
                            praesi.N)
}



#'### Vektor einfügen

txt.bverwg$praesi <- unlist(praesi.list)



#'## Variable "v_praesi" hinzufügen
#' Diese Variable dokumentiert für jede Entscheidung welche/r Vize-Präsident:in am Tag der Entscheidung im Amt war.
#' 
#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.



#+
#'### Personaldaten einlesen

vpraesi <- fread("PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv")
vpraesi <- vpraesi[court == "BVerwG", c(1:3, 5:6)]



#'### Personaldaten anzeigen

kable(vpraesi,
      format = "latex",
      align = "r",
      booktabs = TRUE,
      longtable = TRUE) %>% kable_styling(latex_options = "repeat_header")




#'### Hypothethisches Amtsende für Vize-Präsident:in
#' Weil der/die aktuelle Vize-Präsident:in noch im Amt ist, ist der Wert für das Amtsende "NA". Dieser ist aber für die verwendete Logik nicht greifbar, weshalb an dieser Stelle ein hypothetisches Amtsende in einem Jahr ab dem Tag der Datensatzerstellung fingiert wird. Es wird nur an dieser Stelle verwendet und danach verworfen.

vpraesi[is.na(term_end_date)]$term_end_date <- Sys.Date() + 365


#'### Schleife vorbereiten

N <- vpraesi[,.N]

vpraesi.list <- vector("list", N)



#'### Vektor erstellen

for (i in seq_len(N)){
    vpraesi.N <- txt.bverwg[datum >= vpraesi$term_begin_date[i] & datum <= vpraesi$term_end_date[i], .N]
    vpraesi.list[[i]] <- rep(vpraesi$name_last[i],
                            vpraesi.N)
}




#'### Vektor einfügen

txt.bverwg$v_praesi <- unlist(vpraesi.list)




#'## Variable "aktenzeichen" hinzufügen

txt.bverwg$aktenzeichen <- paste0("BVerwG",
                                  " ",
                                  txt.bverwg$spruchkoerper_az,
                                  " ",
                                  txt.bverwg$registerzeichen,
                                  " ",
                                  txt.bverwg$eingangsnummer,
                                  ".",
                                  txt.bverwg$eingangsjahr_az)


txt.bverwg[verzoegerung == "D"]$aktenzeichen <- paste(txt.bverwg[verzoegerung == "D"]$aktenzeichen,
                                                      "D")



txt.bverwg$aktenzeichen <- gsub(" NA ",
                                " ",
                                txt.bverwg$aktenzeichen)




#'## Variable "ecli" hinzufügen
#' Struktur und Inhalt der ECLI für deutsche Gerichte sind auf dem Europäischen Justizportal näher erläutert. \footnote{\url{https://e-justice.europa.eu/content_european_case_law_identifier_ecli-175-de-de.do?member=1}}
#'
#' Sofern die Variablen korrekt extrahiert wurden lässt sich die ECLI vollständig rekonstruieren.

#+
#'### Ordinalzahl erstellen

ecli.ordinalzahl <- paste0(format(txt.bverwg$datum,
                                  "%d%m%y"),
                           txt.bverwg$entscheidung_typ,
                           txt.bverwg$spruchkoerper_az,
                           gsub("-",
                                "",
                                txt.bverwg$registerzeichen),
                           txt.bverwg$eingangsnummer,
                           ".",
                           formatC(txt.bverwg$eingangsjahr_az,
                                   width = 2,
                                   flag = "0"),
                           ifelse(is.na(txt.bverwg$verzoegerung),
                                  ".",
                                  txt.bverwg$verzoegerung),
                           txt.bverwg$kollision)


ecli.ordinalzahl <- gsub("NA",
                         "",
                         ecli.ordinalzahl)






#'### Tabelle der Soll- und Ist-Ordinalzahlen vorbereiten
#' Die im vorigen Schritt generierten ECLI-Ordinalzahlen ("ist") werden nun noch einmal mit den in den Links angegebenen ECLI-Ordinalzahlen ("soll") gegenübergestellt um sicherzustellen, dass es sich um gültige ECLIs handelt.
#'
#' Berücksichtigt werden im folgenden nur Dateien die tatsächlich heruntergeladen wurden.

files.pdf <- list.files(pattern = "\\.pdf$",
                        ignore.case = TRUE)

eclitest.index <- dt.download$filenames.final %in% files.pdf

eclitest.links <- dt.download$links.pdf[eclitest.index]
eclitest.pdf <- dt.download$filenames.final[eclitest.index]

soll <- basename(eclitest.links)



#' Bei einigen PDF-Dateien sind die Soll-Ordinalzahlen (z.B. "010806B1WDS-VR3.06.0" und "130607B1WDS-VR2.07.0") in den Links fehlerhaft, weil Bindestriche im ECLI-System nicht vorgesehen sind. Für diese Dateien werden vor dem Abgleich Korrekturen vorgenommen.

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


#' Bei diesen Entscheidungen sind die Links fehlerhaft.  Die korrekten ECLI-Ordinalzahlen für die beiden Entscheidungen stammen jeweils aus dem Text des PDF-Dokumentes.

soll <- gsub("030206BPKH1.062.06.0",
                  "030206B8PKH1.06.0",
                  soll)

soll <- gsub("190405BVR1011.041012.04.0",
                  "190405B4VR1011.04.0",
                  soll)




#'### Tabelle der Soll- und Ist-Ordinalzahlen erstellen

ist <- ecli.ordinalzahl

soll <- soll[match(files.pdf,
                   eclitest.pdf)]


ecli.o.check <- data.table(soll,
                           ist)
print(ecli.o.check)


#'### Prüfung ob alle ECLI-Ordinalzahlen korrekt sind

identical(ecli.o.check$soll,
          ecli.o.check$ist)


#'### Fehlerhafte ECLI-Ordinalzahlen anzeigen

diff <- setdiff(ecli.o.check$soll, ecli.o.check$ist)
ecli.o.check[soll %in% diff]



#'### Vollständige ECLI erstellen und einfügen

txt.bverwg$ecli <- paste0("ECLI:DE:BVerwG:",
                          txt.bverwg$entscheidungsjahr,
                          ":",
                          ecli.ordinalzahl)


#'### ECLI-Beispiele

sample(txt.bverwg$ecli,
       10)





#'## Variable "verfahrensart" hinzufügen
#'Die Registerzeichen werden an dieser Stelle mit ihren detaillierten Bedeutungen aus dem folgenden Datensatz abgeglichen: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564." Das Ergebnis des Abgleichs wird in der Variable "verfahrensart" in den Datensatz eingefügt.


#+
#'### Datensatz einlesen
az.source <- fread("AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv")




#'### Datensatz auf relevante Daten reduzieren
az.bverwg <- az.source[stelle == "BVerwG" & position == "hauptzeichen"]


#'### Indizes bestimmen
targetindices <- match(txt.bverwg$registerzeichen,
                       az.bverwg$zeichen_code)

#'### Vektor der Verfahrensarten erstellen und einfügen
txt.bverwg$verfahrensart <- az.bverwg$bedeutung[targetindices]





#'## Variable "doi_concept" hinzufügen

txt.bverwg$doi_concept <- rep(doi.concept,
                              txt.bverwg[,.N])


#'## Variable "doi_version" hinzufügen

txt.bverwg$doi_version <- rep(doi.version,
                              txt.bverwg[,.N])


#'## Variable "version" hinzufügen

txt.bverwg$version <- as.character(rep(datestamp,
                                       txt.bverwg[,.N]))


#'## Variable "lizenz" hinzufügen
txt.bverwg$lizenz <- as.character(rep(license,
                                   txt.bverwg[,.N]))




#'# Frequenztabellen erstellen

#+
#'## Funktion anzeigen

#+ results = "asis"
print(f.fast.freqtable)


#'## Ignorierte Variablen
print(varremove)



#'## Liste zu prüfender Variablen

varlist <- names(txt.bverwg)

varlist <- setdiff(varlist,
                   varremove)

print(varlist)



#'## Frequenztabellen erstellen

prefix <- paste0(datasetname,
                 "_01_Frequenztabelle_var-")


#+ results = "asis"
f.fast.freqtable(txt.bverwg,
                 varlist = varlist,
                 sumrow = TRUE,
                 output.list = FALSE,
                 output.kable = TRUE,
                 output.csv = TRUE,
                 outputdir = outputdir,
                 prefix = prefix,
                 align = c("p{5cm}",
                           rep("r", 4)))






#'# Frequenztabellen visualisieren

#'## Präfix erstellen

prefix <- paste0("ANALYSE/",
                 datasetname,
                 "_01_Frequenztabelle_var-")


#'## Tabellen einlesen

table.entsch.typ <- fread(paste0(prefix,
                                 "entscheidung_typ.csv"))

table.spruch.az <- fread(paste0(prefix,
                                "spruchkoerper_az.csv"))

table.regz <- fread(paste0(prefix,
                           "registerzeichen.csv"))

table.jahr.eingangISO <- fread(paste0(prefix,
                                      "eingangsjahr_iso.csv"))

table.jahr.entscheid <- fread(paste0(prefix,
                                     "entscheidungsjahr.csv"))

table.output.praesi <- fread(paste0(prefix,
                                    "praesi.csv"))

table.output.vpraesi <- fread(paste0(prefix,
                                     "v_praesi.csv"))





#'\newpage
#'## Diagramm: Typ der Entscheidung

freqtable <- table.entsch.typ[-.N]


#+ CE-BVerwG_02_Barplot_Entscheidungstyp, fig.height = 6, fig.width = 9
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(entscheidung_typ,
                             -N),
                 y = N),
             stat = "identity",
             fill = "#7e0731",
             color = "black",
             width = 0.5) +
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Typ"),
        caption = figure.caption,
        x = "Typ der Entscheidung",
        y = "Entscheidungen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )




#'\newpage
#'## Diagramm: Spruchkörper (Aktenzeichen)

freqtable <- table.spruch.az[-.N][,lapply(.SD, as.numeric)]


#+ CE-BVerwG_03_Barplot_Spruchkoerper_AZ, fig.height = 6, fig.width = 9
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(spruchkoerper_az,
                             -N),
                 y = N),
             stat = "identity",
             fill = "#7e0731",
             color = "black",
             width = 0.5) +
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Senat (Aktenzeichen)"),
        caption = figure.caption,
        x = "Senat",
        y = "Entscheidungen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )





#'\newpage
#'## Diagramm: Registerzeichen

freqtable <- table.regz[-.N]

#+ CE-BVerwG_04_Barplot_Registerzeichen, fig.height = 10, fig.width = 8
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(registerzeichen,
                             N),
                 y = N),
             stat = "identity",
             fill = "#7e0731",
             color = "black") +
    coord_flip()+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Registerzeichen"),
        caption = figure.caption,
        x = "Registerzeichen",
        y = "Entscheidungen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Diagramm: Präsident:in

freqtable <- table.output.praesi[-.N]

#+ CE-BVerwG_05_Barplot_PraesidentIn, fig.height = 6, fig.width = 9
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(praesi,
                             N),
                 y = N),
             stat = "identity",
             fill = "#7e0731",
             color = "black") +
    coord_flip()+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Präsident:in"),
        caption = figure.caption,
        x = "Präsident:in",
        y = "Entscheidungen"
    )+
    theme(
        axis.title.y = element_blank(),
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Diagramm: Vize-Präsident:in

freqtable <- table.output.vpraesi[-.N]

#+ CE-BVerwG_06_Barplot_VizePraesidentIn, fig.height = 6, fig.width = 9
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(v_praesi,
                             N),
                 y = N),
             stat = "identity",
             fill = "#7e0731",
             color = "black") +
    coord_flip()+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Vize-Präsident:in"),
        caption = figure.caption,
        x = "Vize-Präsident:in",
        y = "Entscheidungen"
    )+
    theme(
        axis.title.y = element_blank(),
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Diagramm: Entscheidungsjahr

freqtable <- table.jahr.entscheid[-.N][,lapply(.SD, as.numeric)]

#+ CE-BVerwG_07_Barplot_Entscheidungsjahr, fig.height = 6, fig.width = 9
ggplot(data = freqtable) +
    geom_bar(aes(x = entscheidungsjahr,
                 y = N),
             stat = "identity",
             fill = "#7e0731") +
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Entscheidungsjahr"),
        caption = figure.caption,
        x = "Entscheidungsjahr",
        y = "Entscheidungen"
    )+
    theme(
        text = element_text(size = 16),
        plot.title = element_text(size = 16,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Diagramm: Eingangsjahr (ISO)

freqtable <- table.jahr.eingangISO[-.N][,lapply(.SD, as.numeric)]



#+ CE-BVerwG_08_Barplot_EingangsjahrISO, fig.height = 6, fig.width = 9
ggplot(data = freqtable) +
    geom_bar(aes(x = eingangsjahr_iso,
                 y = N),
             stat = "identity",
             fill = "#7e0731") +
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Entscheidungen je Eingangsjahr (ISO)"),
        caption = figure.caption,
        x = "Eingangsjahr (ISO)",
        y = "Entscheidungen"
    )+
    theme(
        text = element_text(size = 16),
        plot.title = element_text(size = 16,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )





#'# Korpus-Analytik
#'

#+
#'## Berechnung linguistischer Kennwerte
#' An dieser Stelle werden für jedes Dokument die Anzahl Tokens, Typen und Sätze berechnet und mit den jeweiligen Metadaten verknüpft. Das Ergebnis ist grundsätzlich identisch mit dem eigentlichen Datensatz, nur ohne den Text der Entscheidungen.


#+
#'### Funktion anzeigen
print(f.lingsummarize.iterator)


#'### Berechnung durchführen
summary.corpus <- f.lingsummarize.iterator(txt.bverwg,
                                       threads = fullCores,
                                       chunksize = 1)



#'### Variablen-Namen anpassen

setnames(summary.corpus,
         old = c("nchars",
                 "ntokens",
                 "ntypes",
                 "nsentences"),
         new = c("zeichen",
                 "tokens",
                 "typen",
                 "saetze"))

#'## Kennwerte dem Korpus hinzufügen

txt.bverwg <- cbind(txt.bverwg,
                    summary.corpus)


#'## Variante mit Metadaten erstellen
meta.bverwg <- txt.bverwg[, !"text"]





#'\newpage
#'## Linguistische Kennwerte

#+
#'### Zusammenfassungen berechnen


dt.summary.ling <- meta.bverwg[, lapply(.SD,
                                           function(x)unclass(summary(x))),
                                  .SDcols = c("zeichen",
                                              "tokens",
                                              "typen",
                                              "saetze")]


dt.sums.ling <- meta.bverwg[,
                            lapply(.SD, sum),
                            .SDcols = c("zeichen",
                                        "tokens",
                                        "typen",
                                        "saetze")]



tokens.temp <- tokens(corpus(txt.bverwg),
                      what = "word",
                      remove_punct = FALSE,
                      remove_symbols = FALSE,
                      remove_numbers = FALSE,
                      remove_url = FALSE,
                      remove_separators = TRUE,
                      split_hyphens = FALSE,
                      include_docvars = FALSE,
                      padding = FALSE
                      )


dt.sums.ling$typen <- nfeat(dfm(tokens.temp))




dt.stats.ling <- rbind(dt.sums.ling,
                       dt.summary.ling)

dt.stats.ling <- transpose(dt.stats.ling,
                           keep.names = "names")


setnames(dt.stats.ling, c("Variable",
                          "Sum",
                          "Min",
                          "Quart1",
                          "Median",
                          "Mean",
                          "Quart3",
                          "Max"))


#'### Zusammenfassungen anzeigen

kable(dt.stats.ling,
      format.args = list(big.mark = ","),
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)




#'### Zusammenfassungen speichern

fwrite(dt.stats.ling,
       paste0(outputdir,
              datasetname,
              "_00_KorpusStatistik_ZusammenfassungLinguistisch.csv"),
       na = "NA")




#'\newpage
#'## Quantitative Variablen


#'### Entscheidungsdatum

summary(as.IDate(meta.bverwg$datum))



#'### Zusammenfassungen berechnen

dt.summary.docvars <- meta.bverwg[,
                                     lapply(.SD, function(x)unclass(summary(na.omit(x)))),
                                     .SDcols = c("entscheidungsjahr",
                                                 "eingangsjahr_iso",
                                                 "eingangsnummer")]


dt.unique.docvars <- meta.bverwg[,
                                    lapply(.SD, function(x)length(unique(na.omit(x)))),
                                    .SDcols = c("entscheidungsjahr",
                                                "eingangsjahr_iso",
                                                "eingangsnummer")]


dt.stats.docvars <- rbind(dt.unique.docvars,
                          dt.summary.docvars)

dt.stats.docvars <- transpose(dt.stats.docvars,
                              keep.names = "names")


setnames(dt.stats.docvars, c("Variable",
                             "Unique",
                             "Min",
                             "Quart1",
                             "Median",
                             "Mean",
                             "Quart3",
                             "Max"))


#'\newpage
#'### Zusammenfassungen anzeigen

kable(dt.stats.docvars,
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)



#'### Zusammenfassungen speichern

fwrite(dt.stats.docvars,
       paste0(outputdir,
              datasetname,
              "_00_KorpusStatistik_ZusammenfassungDocvarsQuantitativ.csv"),
       na = "NA")




#'\newpage
#'## Verteilungen linguistischer Kennwerte

#+
#'### Diagramm: Verteilung Zeichen

#+ CE-BVerwG_09_Density_Zeichen, fig.height = 6, fig.width = 9
ggplot(data = meta.bverwg)+
    geom_density(aes(x = zeichen),
                 fill = "#7e0731")+
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw()+
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Zeichen je Dokument"),
        caption = figure.caption,
        x = "Zeichen",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#+
#'### Diagramm: Verteilung Tokens

#+ CE-BVerwG_10_Density_Tokens, fig.height = 6, fig.width = 9
ggplot(data = meta.bverwg)+
    geom_density(aes(x = tokens),
                 fill = "#7e0731")+
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw()+
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Tokens je Dokument"),
        caption = figure.caption,
        x = "Tokens",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )




#'\newpage
#'### Diagramm: Verteilung Typen

#+ CE-BVerwG_11_Density_Typen, fig.height = 6, fig.width = 9
ggplot(data = meta.bverwg)+
    geom_density(aes(x = typen),
                 fill = "#7e0731")+
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw()+
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Typen je Dokument"),
        caption = figure.caption,
        x = "Typen",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'### Diagramm: Verteilung Sätze

#+ CE-BVerwG_12_Density_Saetze, fig.height = 6, fig.width = 9
ggplot(data = meta.bverwg)+
    geom_density(aes(x = saetze),
                 fill = "#7e0731")+
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^6))+
    theme_bw()+
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Sätze je Dokument"),
        caption = figure.caption,
        x = "Sätze",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )







#'# Linguistische Annotationen berechnen

if (mode.annotate == TRUE){

    txt.annotated <- f.dopar.spacyparse(txt.bverwg,
                                        threads = detectCores(),
                                        chunksize = 1,
                                        model = "de_core_news_sm",
                                        pos = TRUE,
                                        tag = TRUE,
                                        lemma = TRUE,
                                        entity = TRUE,
                                        dependency = TRUE,
                                        nounphrase = TRUE)

}








#'# Kontrolle der Variablen

#+
#'## Semantische Sortierung der Variablen

#+
#'### Variablen sortieren: Hauptdatensatz


setcolorder(txt.bverwg,
            c("doc_id",
              "text",
              "gericht",
              "datum",
              "entscheidung_typ", 
              "spruchkoerper_az",
              "registerzeichen",
              "verfahrensart",
              "eingangsnummer",
              "eingangsjahr_az",
              "eingangsjahr_iso",
              "entscheidungsjahr",
              "verzoegerung",
              "kollision",
              "aktenzeichen",
              "aktenzeichen_alle",
              "ecli",
              "zitiervorschlag",
              "kurzbeschreibung",
              "pressemitteilung",
              "praesi",
              "v_praesi",
              "richter",
              "zeichen",
              "tokens",
              "typen",            
              "saetze",
              "version",
              "doi_concept",      
              "doi_version",
              "lizenz"))


#'\newpage
#+
#'### Variablen sortieren: Metadaten

setcolorder(meta.bverwg,
            c("doc_id",
              "gericht",
              "datum",
              "entscheidung_typ", 
              "spruchkoerper_typ",
              "spruchkoerper_az",
              "registerzeichen",
              "verfahrensart",
              "eingangsnummer",
              "eingangsjahr_az",
              "eingangsjahr_iso",
              "entscheidungsjahr",
              "kollision",
              "name",
              "band",
              "seite",  
              "aktenzeichen",
              "aktenzeichen_alle",
              "ecli",
              "zitiervorschlag",
              "kurzbeschreibung",
              "pressemitteilung",
              "praesi",
              "v_praesi",
              "richter",
              "zeichen",
              "tokens",
              "typen",            
              "saetze",
              "version",
              "doi_concept",      
              "doi_version",
              "lizenz"))

#'\newpage
#+
#'### Variablen sortieren: Segmentiert


setcolorder(dt.segmented.full,
            c("doc_id",
              "text",
              "segment",
              "gericht",
              "datum",
              "entscheidung_typ", 
              "spruchkoerper_typ",
              "spruchkoerper_az",
              "registerzeichen",
              "verfahrensart",
              "eingangsnummer",
              "eingangsjahr_az",
              "eingangsjahr_iso",
              "entscheidungsjahr",
              "kollision",
              "name",
              "band",
              "seite",  
              "aktenzeichen",
              "aktenzeichen_alle",
              "ecli",
              "zitiervorschlag",
              "kurzbeschreibung",
              "pressemitteilung",
              "praesi",
              "v_praesi",
              "richter",
              "version",
              "doi_concept",      
              "doi_version",
              "lizenz"))


#'\newpage
#'## Anzahl Variablen der Datensätze

length(txt.bverwg)
length(meta.bverwg)
length(txt.annotated)
length(dt.segmented.full)


#'## Alle Variablen-Namen der Datensätze

names(txt.bverwg)
names(meta.bverwg)
names(txt.annotated)
names(dt.segmented.full)







#'# Beispiel-Werte für alle Metadaten anzeigen
print(meta.bverwg)



#'# CSV-Dateien erstellen

#+
#'## CSV mit vollem Datensatz speichern

csvname.full <- paste(datasetname,
                      datestamp,
                      "DE_CSV_Datensatz.csv",
                      sep = "_")

fwrite(txt.bverwg,
       csvname.full,
       na = "NA")




#'## CSV mit Metadaten speichern
#' Diese Datei ist grundsätzlich identisch mit dem eigentlichen Datensatz, nur ohne den Text der Entscheidungen.

csvname.meta <- paste(datasetname,
                      datestamp,
                      "DE_CSV_Metadaten.csv",
                      sep = "_")

fwrite(meta.bverwg,
       csvname.meta,
       na = "NA")



#'## CSV mit Annotationen speichern

if (mode.annotate == TRUE){

    csvname.annotated <- paste(datasetname,
                               datestamp,
                               "DE_CSV_Annotiert.csv",
                               sep = "_")

    fwrite(txt.annotated,
           csvname.annotated,
           na = "NA")

}




#'# Dateigrößen analysieren

#+
#'## Gesamtgröße

#+
#'### Korpus-Objekt in RAM (MB)

print(object.size(txt.bverwg),
      standard = "SI",
      humanReadable = TRUE,
      units = "MB")


#'### CSV Korpus (MB)
file.size(csvname.full) / 10 ^ 6


#'### CSV Metadaten (MB)
file.size(csvname.meta) / 10 ^ 6

#'### CSV Annotiert (MB)
file.size(csvname.annotated) / 10 ^ 6


#'### PDF-Dateien (MB)

files.pdf <- list.files(pattern = "\\.pdf$",
                        ignore.case = TRUE)

pdf.MB <- file.size(files.pdf) / 10^6
sum(pdf.MB)


#'### TXT-Dateien (MB)

files.txt <- list.files(pattern = "\\.txt$",
                        ignore.case = TRUE)

txt.MB <- file.size(files.txt) / 10^6
sum(txt.MB)





#'\newpage
#'## Diagramm: Verteilung der Dateigrößen (PDF)

dt.plot <- data.table(pdf.MB)

#+ CE-BVerwG_13_Density_Dateigroessen_PDF, fig.height = 6, fig.width = 9
ggplot(data = dt.plot,
       aes(x = pdf.MB)) +
    geom_density(fill = "#7e0731") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Dateigrößen (PDF)"),
        caption = figure.caption,
        x = "Dateigröße in MB",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        panel.spacing = unit(0.1, "lines"),
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Diagramm: Verteilung der Dateigrößen (TXT)

dt.plot <- data.table(txt.MB)

#+ CE-BVerwG_14_Density_Dateigroessen_TXT, fig.height = 6, fig.width = 9
ggplot(data = dt.plot,
       aes(x = txt.MB)) +
    geom_density(fill = "#7e0731") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Dateigrößen (TXT)"),
        caption = figure.caption,
        x = "Dateigröße in MB",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        panel.spacing = unit(0.1, "lines"),
        plot.margin = margin(10, 20, 10, 10)
    )





#'# Erstellen der ZIP-Archive

#+
#'## Verpacken der CSV-Dateien

#+
#'### Vollständiger Datensatz

#+ results = 'hide'
csvname.full.zip <- gsub(".csv",
                         ".zip",
                         csvname.full)

zip(csvname.full.zip,
    csvname.full)

unlink(csvname.full)


#+
#'### Metadaten

#+ results = 'hide'
csvname.meta.zip <- gsub(".csv",
                         ".zip",
                         csvname.meta)

zip(csvname.meta.zip,
    csvname.meta)

unlink(csvname.meta)



#+
#'### Annotiert


#+ results = 'hide'
if (mode.annotate == TRUE){

    csvname.annotated.zip <- gsub(".csv",
                                  ".zip",
                                  csvname.annotated)

    zip(csvname.annotated.zip,
        csvname.annotated)

    unlink(csvname.annotated)

}




#'## Verpacken der PDF-Dateien


#+ results = 'hide'
files.pdf <- list.files(pattern = "\\.pdf",
                        ignore.case = TRUE)

zip(paste(datasetname,
          datestamp,
          "DE_PDF_Datensatz.zip",
          sep = "_"),
    files.pdf)

unlink(files.pdf)


#'## Verpacken der TXT-Dateien

#+ results = 'hide'
files.txt <- list.files(pattern = "\\.txt",
                        ignore.case = TRUE)

zip(paste(datasetname,
          datestamp,
          "DE_TXT_Datensatz.zip",
          sep = "_"),
    files.txt)

unlink(files.txt)


#'## Verpacken der Analyse-Dateien

zip(paste0(datasetname,
           "_",
           datestamp,
           "_DE_",
           basename(outputdir),
           ".zip"),
    basename(outputdir))




#'## Verpacken der Source-Dateien

files.source <- c(list.files(pattern = "Source"),
                  "buttons",
                  "R-fobbe-proto-package")


files.source <- grep("spin",
                     files.source,
                     value = TRUE,
                     ignore.case = TRUE,
                     invert = TRUE)

zip(paste(datasetname,
           datestamp,
           "Source_Files.zip",
           sep = "_"),
    files.source)





#'# Kryptographische Hashes
#' Dieses Modul berechnet für jedes ZIP-Archiv zwei Arten von Hashes: SHA2-256 und SHA3-512. Mit diesen kann die Authentizität der Dateien geprüft werden und es wird dokumentiert, dass sie aus diesem Source Code hervorgegangen sind. Die SHA-2 und SHA-3 Algorithmen sind äußerst resistent gegenüber *collision* und *pre-imaging* Angriffen, sie gelten derzeit als kryptographisch sicher. Ein SHA3-Hash mit 512 bit Länge ist nach Stand von Wissenschaft und Technik auch gegenüber quantenkryptoanalytischen Verfahren unter Einsatz des *Grover-Algorithmus* hinreichend resistent.

#+
#'## Liste der ZIP-Archive erstellen
files.zip <- list.files(pattern = "\\.zip$",
                        ignore.case = TRUE)


#'## Funktion anzeigen
#+ results = "asis"
print(f.dopar.multihashes)

#'## Hashes berechnen
multihashes <- f.dopar.multihashes(files.zip)


#'## In Data Table umwandeln
setDT(multihashes)



#'## Index hinzufügen
multihashes$index <- seq_len(multihashes[,.N])


#'\newpage
#'## In Datei schreiben
fwrite(multihashes,
       paste(datasetname,
             datestamp,
             "KryptographischeHashes.csv",
             sep = "_"),
       na = "NA")


#'## Leerzeichen hinzufügen um Zeilenumbruch zu ermöglichen
multihashes$sha3.512 <- paste(substr(multihashes$sha3.512, 1, 64),
                              substr(multihashes$sha3.512, 65, 128))



#'## In Bericht anzeigen

kable(multihashes[,.(index,filename)],
      format = "latex",
      align = c("p{1cm}",
                "p{13cm}"),
      booktabs = TRUE,
      longtable = TRUE)

#'\newpage
kable(multihashes[,.(index,sha2.256)],
      format = "latex",
      align = c("c",
                "p{13cm}"),
      booktabs = TRUE,
      longtable = TRUE)


kable(multihashes[,.(index,sha3.512)],
      format = "latex",
      align = c("c",
                "p{13cm}"),
      booktabs = TRUE,
      longtable = TRUE)





#'# Abschluss

#+
#'## Datumsstempel
print(datestamp)


#'## Datum und Uhrzeit (Anfang)
print(begin.script)


#'## Datum und Uhrzeit (Ende)
end.script <- Sys.time()
print(end.script)


#'## Laufzeit des gesamten Skriptes
print(end.script - begin.script)


#'## Warnungen
warnings()



#'# Parameter für strenge Replikationen

system2("openssl", "version", stdout = TRUE)

sessionInfo()


#'# Literaturverzeichnis

