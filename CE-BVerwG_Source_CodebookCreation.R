#'---
#'title: "Codebook | Corpus der Entscheidungen des Bundesverwaltungsgerichts (CE-BVerwG)"
#'author: Seán Fobbe
#'geometry: margin=3cm
#'papersize: a4
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CE-BVerwG_Source_TEX_Definitions.tex,CE-BVerwG_Source_TEX_CodebookTitle.tex]
#'bibliography: packages.bib
#'nocite: '@*'
#' ---

#'\newpage

#+ echo = FALSE 
knitr::opts_chunk$set(fig.pos = "center",
                      echo = FALSE,
                      warning = FALSE,
                      message = FALSE)


############################
### Packages
############################

#+

library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Automatisierte Tabellen
library(magick)       # Fortgeschrittene Verarbeitung von Grafiken
library(parallel)     # Parallelisierung in Base R
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Log-Skalen
library(data.table)   # Fortgeschrittene Datenverarbeitung

setDTthreads(threads = detectCores()) 


###################################
### Zusätzliche Funktionen einlesen
###################################

source("General_Source_Functions.R")



############################
### Vorbereitung
############################

datasetname <- "CE-BVerwG"
doi.concept <- "10.5281/zenodo.3911067" # checked
doi.version <- "???" # checked


files.zip <- list.files(pattern = "\\.zip")

datestamp <- unique(tstrsplit(files.zip,
                              split = "_")[[2]])



prefix <- paste0("ANALYSE/",
                 datasetname,
                 "_")


############################
### Registerzeichen
############################

## Die Registerzeichen und ihre Bedeutungen stammen aus dem folgenden Datensatz: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564."


## Datensatz herunterladen

if (file.exists("AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv") == FALSE){
    download.file("https://zenodo.org/record/4569564/files/AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv?download=1",
 "AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv")
    }


## Datensatz einlesen
az.source <- fread("AZ-BRD_1-0-1_DE_Registerzeichen_Datensatz.csv")

## Datensatz auf relevante Daten reduzieren
table.registerzeichen <- az.source[stelle == "BVerwG" & position == "hauptzeichen"]




################################
### Einlesen: Frequenztabellen
################################

table.entsch.typ <- fread(paste0(prefix,
                                 "01_Frequenztabelle_var-entscheidung_typ.csv"),
                          drop = 3)

table.spruch.az <- fread(paste0(prefix,
                                "01_Frequenztabelle_var-spruchkoerper_az.csv"),
                         drop = 3)


table.regz <- fread(paste0(prefix,
                           "01_Frequenztabelle_var-registerzeichen.csv"),
                    drop = 3)

table.jahr.eingangISO <- fread(paste0(prefix,
                                      "01_Frequenztabelle_var-eingangsjahr_iso.csv"),
                               drop = 3)

table.jahr.entscheid <- fread(paste0(prefix,
                                     "01_Frequenztabelle_var-entscheidungsjahr.csv"),
                              drop = 3)

table.output.praesi <- fread(paste0(prefix,
                                    "01_Frequenztabelle_var-praesi.csv"),
                             drop = 3)

table.output.vpraesi <- fread(paste0(prefix,
                                     "01_Frequenztabelle_var-v_praesi.csv"),
                              drop = 3)



######################################
### Einlesen: Personaldaten
######################################

## Die Personaldaten stammen aus folgendem Datensatz: Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682.


#+
## Personaldaten herunterladen

if (file.exists("PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv") == FALSE){
    download.file("https://zenodo.org/record/4568682/files/PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv?download=1",
 "PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv")
    }



#+
## Personaldaten einlesen

table.praesi <- fread("PVP-FCG_2021-04-08_GermanFederalCourts_Presidents.csv")


table.praesi.daten <- table.praesi[court == "BVerwG", c(2:3, 5:8)]
table.praesi.alter <- table.praesi[court == "BVerwG", c(2:3, 13:15)]






#+
## Personaldaten herunterladen

if (file.exists("PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv") == FALSE){
    download.file("https://zenodo.org/record/4568682/files/PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv?download=1",
 "PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv")
    }



#+
## Personaldaten einlesen

table.vpraesi <- fread("PVP-FCG_2021-04-08_GermanFederalCourts_VicePresidents.csv")



table.vpraesi.daten <- table.vpraesi[court == "BVerwG", c(2:3, 5:8)]
table.vpraesi.alter <- table.vpraesi[court == "BVerwG", c(2:3, 13:15)]




######################################
### Einlesen: Linguistische Kennwerte
######################################


stats.ling <-  fread(paste0(prefix,
                            "00_KorpusStatistik_ZusammenfassungLinguistisch.csv"))

stats.docvars <- fread(paste0(prefix,
                              "00_KorpusStatistik_ZusammenfassungDocvarsQuantitativ.csv"))





######################################
### Einlesen: Datensatz
######################################

summary.zip <- paste(datasetname,
                     datestamp,
                     "DE_CSV_Metadaten.zip",
                     sep = "_")

summary.corpus <- fread(cmd = paste("unzip -cq",
                                    summary.zip))



data.zip <- paste(datasetname,
                     datestamp,
                     "DE_CSV_Datensatz.zip",
                     sep = "_")

data.corpus <- fread(cmd = paste("unzip -cq",
                                 data.zip))



################################
### Einlesen: Signaturen
################################

hashfile <- paste(datasetname,
                  datestamp,
                  "KryptographischeHashes.csv", sep = "_")

signaturefile <- paste(datasetname,
                       datestamp,
                       "FobbeSignaturGPG_Hashes.gpg", sep = "_")



################################
### Beginn Text
################################



#'# Einführung

#' Das **\court\ (\courtshort)** ist einer der fünf obersten Gerichtshöfe des Bundes und steht an der Spitze der Verwaltungsgerichtsbarkeit der Bundesrepublik Deutschland. Im Rahmen der Verwaltungsgerichtsbarkeit ist es für alle öffentlich-rechtlichen Streitigkeiten nichtverfassungsrechtlicher Art zuständig (§ 40 Absatz 1 Satz 1 VwGO). Es wurde am 23. September 1952 durch Bundesgesetz errichtet.\footnote{Gesetz über das Bundesverwaltungsgericht, 23. September 1952, BGBl. I, S. 625.}
#'
#' Am \court\ eingerichtet sind derzeit 13 reguläre Senate, davon zehn Revisionssenate, zwei Wehrdienstsenate und ein Fachsenat nach § 189 VwGO.\footnote{Geschäftsverteilungsplan des Bundesverwaltungsgerichts für das Geschäftsjahr 2021. <\url {https://www.bverwg.de/rechtsprechung/geschaeftsverteilungsplan}>} Zusätzlich besteht ein Großer Senat nach § 11 VwGO und es sind Güterichter nach § 173 Satz 1 VwGO benannt.\footnote{Ibid.} Die drei Disziplinarsenate wurden 1971, 2004 und 2015 aufgelöst.
#'
#' Die weit überwiegende Anzahl der Verfahren vor dem Bundesverwaltungsgericht sind Revisionen, d.h. die Überprüfung von Entscheidungen unterer Instanzen (Verwaltungsgericht, Oberverwaltungsgericht/Verwaltungsgerichtshof) auf Rechtsfehler ohne erneute Beweisaufnahme (§§ 49, 132 ff VwGO).\footnote{Baden-Württemberg, Bayern und Hessen machen von der Option in § 184 VwGO Gebrauch und bezeichnen ihr Oberverwaltungsgericht als \enquote{Verwaltungsgerichtshof}.} In wenigen Fällen --- beispielsweise Klagen zwischen Bund und Bundesländern, zwischen Bundesländern, Vereinsverboten und Angelegenheiten des Bundesnachrichtendienstes --- ist das \court\ erste und letzte Instanz (§\ 50 VwGO).
#'
#'
#' 
#'Die quantitative Analyse von juristischen Texten, insbesondere denen des \court s, ist in den deutschen Rechtswissenschaften ein noch junges und kaum bearbeitetes Feld.\footnote{Besonders positive Ausnahmen finden sich unter: \url{https://www.quantitative-rechtswissenschaft.de/}} Zu einem nicht unerheblichen Teil liegt dies auch daran, dass die Anzahl an frei nutzbaren Datensätzen außerordentlich gering ist.
#' 
#'Die meisten hochwertigen Datensätze lagern (fast) unerreichbar in kommerziellen Datenbanken und sind wissenschaftlich gar nicht oder nur gegen Entgelt zu nutzen. Frei verfügbare Datenbanken wie \emph{Opinio Iuris}\footnote{\url{https://opinioiuris.de/}} und \emph{openJur}\footnote{\url{https://openjur.de/}} verbieten ausdrücklich das maschinelle Auslesen der Rohdaten.\footnote{Openjur beabsichtigt eine API anzubieten, diese war \the\year\ aber immernoch nicht verfügbar. Openjur ist seit 2008 in Betrieb.} Wissenschaftliche Initiativen wie der Juristische Referenzkorpus (JuReKo) sind nach jahrelanger Arbeit hinter verschlossenen Türen verschwunden.
#' 
#'In einem funktionierenden Rechtsstaat muss die Rechtsprechung öffentlich, transparent und nachvollziehbar sein. Im 21. Jahrhundert bedeutet dies auch, dass sie systematischer Überprüfung mittels quantitativen Analysen zugänglich sein muss. Der Erstellung und Aufbereitung des Datensatzes liegen daher die Prinzipien der allgemeinen Verfügbarkeit durch Urheberrechtsfreiheit, strenge Transparenz und vollständige wissenschaftliche Reproduzierbarkeit zugrunde. Die FAIR-Prinzipien (Findable, Accessible, Interoperable and Reusable) für freie wissenschaftliche Daten inspirieren sowohl die Konstruktion, als auch die Art der Publikation.\footnote{Wilkinson, M., Dumontier, M., Aalbersberg, I. et al. The FAIR Guiding Principles for Scientific Data Management and Stewardship. Sci Data 3, 160018 (2016). \url{https://doi.org/10.1038/sdata.2016.18}}




#+
#'# Nutzung

#' Die Daten sind in offenen, interoperablen und weit verbreiteten Formaten (CSV, TXT, PDF) veröffentlicht. Sie lassen sich grundsätzlich mit allen modernen Programmiersprachen (z.B. Python oder R), sowie mit grafischen Programmen nutzen.
#'
#' **Wichtig:** Nicht vorhandene Werte sind sowohl in den Dateinamen als auch in der CSV-Datei mit "NA" codiert.

#+
#'## CSV-Dateien
#' Am einfachsten ist es die **CSV-Dateien** einzulesen. CSV\footnote{Das CSV-Format ist in RFC 4180 definiert, siehe \url{https://tools.ietf.org/html/rfc4180}} ist ein einfaches und maschinell gut lesbares Tabellen-Format. In diesem Datensatz sind die Werte komma-separiert. Jede Spalte entspricht einer Variable, jede Zeile einer Entscheidung. Die Variablen sind unter Punkt \ref{variablen} genauer erläutert.
#'
#' Zum Einlesen empfehle ich für **R** das package **data.table** (via CRAN verfügbar). Dessen Funktion **fread()** ist etwa zehnmal so schnell wie die normale **read.csv()**-Funktion in Base-R. Sie erkennt auch den Datentyp von Variablen sicherer. Ein Beispiel:

#+ eval = FALSE, echo = TRUE
library(data.table)
dt.bverwg <- fread("filename.csv")


#+
#'## TXT-Dateien
#'Die **TXT-Dateien** inklusive Metadaten können zum Beispiel mit **R** und dem package **readtext** (via CRAN verfügbar) eingelesen werden. Ein Vorschlag:

#+ eval = FALSE, echo = TRUE
library(readtext)
df.bverwg <- readtext("./*.txt",
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




#+
#'# Konstruktion


#+
#'## Beschreibung des Datensatzes
#'Dieser Datensatz ist eine digitale Zusammenstellung von möglichst allen Entscheidungen, die auf der amtlichen Internetpräsenz des \court s (\courtshort) am jeweiligen Stichtag veröffentlicht waren. Die Stichtage für jede Version entsprechen exakt der Versionsnummer.
#'
#'Zusätzlich zu den aufbereiteten maschinenlesbaren Formaten (TXT und CSV) sind die PDF-Rohdaten enthalten, damit Analyst:innen gegebenenfalls ihre eigene Konvertierung vornehmen können. Die PDF-Rohdaten wurden inhaltlich nicht verändert und nur die Dateinamen angepasst um die Lesbarkeit für Mensch und Maschine zu verbessern.


#+
#'## Datenquellen

#'\begin{centering}
#'\begin{longtable}{P{5cm}p{9cm}}

#'\toprule

#' Datenquelle & Fundstelle \\

#'\midrule

#' Primäre Datenquelle & \url{https://www.bverwg.de}\\
#' Source Code & \url{\softwareversionurldoi}\\
#' Personendaten & \url{\personendatenurldoi}\\
#' Registerzeichen & \url{\aktenzeichenurldoi}\\

#'\bottomrule

#'\end{longtable}
#'\end{centering}


#' Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.
#' 
#' Die Tabelle der Registerzeichen und der ihnen zugeordneten Verfahrensarten stammt aus dem folgenden Datensatz: "Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564."




#+
#'## Sammlung der Daten
#'Die Daten wurden unter Beachtung des Robot Exclusion Standard (RES) gesammelt. Der Abruf geschieht ausschließlich über TLS-verschlüsselte Verbindungen. Die Entscheidungen sind laut dem Gericht anonymisiert, aber ungekürzt.
#'

#+
#'## Source Code und Compilation Report
#' Der gesamte Source Code --- sowohl für die Erstellung des Datensatzes, als auch für dieses Codebook --- ist öffentlich einsehbar und dauerhaft erreichbar im wissenschaftlichen Archiv des CERN unter dieser Addresse hinterlegt: \softwareversionurldoi\
#'
#' Mit jeder Kompilierung des vollständigen Datensatzes wird auch ein umfangreicher **Compilation Report** in einem attraktiv designten PDF-Format erstellt (ähnlich diesem Codebook). Der Compilation Report enthält den vollständigen und kommentierten Source Code, dokumentiert relevante Rechenergebnisse, gibt sekundengenaue Zeitstempel an und ist mit einem klickbaren Inhaltsverzeichnis versehen. Er ist zusammen mit dem Source Code hinterlegt. Wenn Sie sich für Details der Herstellung interessieren, lesen Sie diesen bitte zuerst.


#+
#'## Grenzen des Datensatzes
#'Nutzer:innen sollten folgende wichtige Grenzen beachten:
#' 
#'\begin{enumerate}
#'\item Der Datensatz enthält nur das, was das Gericht auch tatsächlich veröffentlicht, nämlich begründete Entscheidungen (\emph{publication bias}).
#'\item Es kann aufgrund technischer Grenzen bzw. Fehler sein, dass manche --- im Grunde verfügbare --- Entscheidungen nicht oder nicht korrekt abgerufen werden (\emph{automation bias}).
#'\item Es werden nur PDF-Dateien abgerufen (\emph{file type bias}). Manche Entscheidungen sind nur als HTML verfügbar. 
#'\item Erst ab dem Jahr 2002 sind begründete Entscheidungen des \court s einigermaßen vollständig veröffentlicht (\emph{temporal bias}). Die Frequenztabellen geben hierzu genauer Auskunft.
#'\end{enumerate}


#+
#'## Urheberrechtsfreiheit von Rohdaten und Datensatz 

#'An den Entscheidungstexten und amtlichen Leitsätzen besteht gem. § 5 Abs. 1 UrhG kein Urheberrecht, da sie amtliche Werke sind. § 5 UrhG ist auf amtliche Datenbanken analog anzuwenden (BGH, Beschluss vom 28.09.2006, I ZR 261/03, \enquote{Sächsischer Ausschreibungsdienst}).
#'
#' Alle eigenen Beiträge (z.B. durch Zusammenstellung und Anpassung der Metadaten) und damit den gesamten Datensatz stelle ich gemäß einer \emph{CC0 1.0 Universal Public Domain Lizenz} vollständig urheberrechtsfrei.



#+
#'## Metadaten

#+
#'### Allgemein
#'Die Metadaten wurden größtenteils aus den Hyperlinks zur jeweiligen Datei extrahiert. Hinzugefügt wurden von mir eine Reihe weitere Variablen, sowie in den Dateinamen der PDF/TXT-Dateien Unter- und Trennstriche, um die Maschinenlesbarkeit zu erleichtern. Der volle Satz an Metadaten ist nur in den CSV-Dateien enthalten. Alle hinzugefügten Metadaten sind vollständig maschinenlesbar dokumentiert. Sie sind entweder im Source Code enthalten, mit dem Source Code zusammen dokumentiert oder über dauerhaft stabile Identifikatoren (z.B. DOI) zitiert.
#' 
#'Die Dateinamen der PDF- und TXT-Dateien enthalten Gerichtsname, Datum (Langform nach ISO-8601, d.h. YYYY-MM-DD), den Typ der Entscheidung, das offizielle Aktenzeichen, die Angabe ob es sich um eine Verzögerungsrüge handelt und eine Kollisions-ID.


#+
#'### Schema für die Dateinamen

#'\begin{verbatim}
#'[gericht]_[datum]_[entscheidung_typ]_[spruchkoerper_az]_[registerzeichen]_
#'[eingangsnummer]_[eingangsjahr_az]_[verzoegerung]_[kollision]
#'\end{verbatim}

#+
#'### Beispiel eines Dateinamens

#'\begin{verbatim}
#' BVerwG_2004-08-12_U_5_C_58_03_NA_0.pdf
#'\end{verbatim}

#+
#'## Qualitätsprüfung

#'Die Typen der Variablen wurden mit \emph{regular expressions} strikt validiert. Die möglichen Werte der jeweiligen Variablen wurden zudem durch Frequenztabellen und Visualisierungen auf ihre Plausibilität geprüft. Insgesamt werden zusammen mit jeder Kompilierung Dutzende Tests zur Qualitätsprüfung durchgeführt. Alle Ergebnisse der Qualitätsprüfungen sind aggregiert im Compilation Report und einzeln im Archiv \enquote{ANALYSE} zusammen mit dem Datensatz veröffentlicht.

#+
#'## Grafische Darstellung
#'
#' Die Robenfarbe der Bundesverwaltungsrichter ist \enquote{karmesinrot}.\footnote{Artikel 1, Absatz II der Anordnung des Bundespräsidenten über die Amtstracht bei dem Bundesverwaltungsgericht in der im Bundesgesetzblatt Teil III, Gliederungsnummer 340-3, veröffentlichten bereinigten Fassung, die zuletzt durch die Anordnung vom 19. Dezember 2001 (BGBl. I S. 3777) geändert worden ist.} Der Hex-Wert hierfür ist vermutlich \#7e0731. Das ist besonders bei der Erstellung thematisch passender Graphen hilfreich. Alle im Compilation Report und diesem Codebook präsentierten Graphen sind in diesem karmesinrot gehalten.






#+
#'# Varianten und Zielgruppen

#' Dieser Datensatz ist in verschiedenen Varianten verfügbar, die sich an unterschiedliche Zielgruppen richten. Zielgruppe sind nicht nur quantitativ forschende Rechtswissenschaftler:innen, sondern auch traditionell arbeitende Jurist:innen. Idealerweise müssen quantitative Methoden ohnehin immer durch qualitative Interpretation, Theoriebildung und kritische Auseinandersetzung verstärkt werden (\emph{mixed methods approach}).
#'
#' Lehrende werden von den vorbereiteten Tabellen und Diagrammen besonders profitieren, die bei der Erläuterung der Charakteristika der Daten hilfreich sein können und Zeit im universitären Alltag sparen. Alle Tabellen und Diagramme liegen auch als separate Dateien vor um sie einfach z.B. in Präsentations-Folien oder Handreichungen zu integrieren.

#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule

#'Variante & Zielgruppe und Beschreibung\\

#'\midrule
#'
#'\endhead

#'PDF & \textbf{Traditionelle juristische Forschung}. Die PDF-Dokumente wie sie vom \court\ auf der amtlichen Webseite bereitgestellt werden, jedoch verbessert durch semantisch hochwertige Dateinamen, die der leichteren Auffindbarkeit von Entscheidungen dienen. Die Dateinamen sind so konzipiert, dass sie auch für die traditionelle qualitative juristische Arbeit einen erheblichen Mehrwert bieten. Im Vergleich zu den CSV-Dateien enthalten die Dateinamen nur einen reduzierten Umfang an Metadaten, um Kompatibilitätsprobleme unter Windows zu vermeiden und die Lesbarkeit zu verbessern.\\
#' CSV\_Datensatz & \textbf{Legal Tech/Quantitative Forschung}. Diese CSV-Datei ist die für statistische Analysen empfohlene Variante des Datensatzes. Sie enthält den Volltext aller Entscheidungen, sowie alle in diesem Codebook beschriebenen Metadaten. Über Zeilenumbrüche getrennte Wörter wurden zusammengefügt.\\
#' CSV\_Metadaten & \textbf{Legal Tech/Quantitative Forschung}. Wie die andere CSV-Datei, nur ohne die Entscheidungstexte. Sinnvoll für Analyst:innen, die sich nur für die Metadaten interessieren und Speicherplatz sparen wollen.\\
#' TXT & \textbf{Subsidiär für alle Zielgruppen}. Diese Variante enthält die vollständigen aus den PDF-Dateien extrahierten Entscheidungstexte, aber nur einen reduzierten Umfang an Metadaten, der dem der PDF-Dateien entspricht. Die TXT-Dateien sind optisch an das Layout der PDF-Dateien angelehnt. Geeignet für qualitativ arbeitende Forscher:innen, die nur wenig Speicherplatz oder eine langsame Internetverbindung zur Verfügung haben oder für quantitativ arbeitende Forscher:innen, die beim Einlesen der CSV-Dateien Probleme haben. Über Zeilenumbrüche getrennte Wörter wurden \emph{nicht} zusammengefügt.\\
#' ANALYSE & \textbf{Alle Lehrenden und Forschenden}. Dieses Archiv enthält alle während dem Kompilierungs- und Prüfprozess erstellten Tabellen (CSV) und Diagramme (PDF, PNG) im Original. Sie sind inhaltsgleich mit den in diesem Codebook verwendeten Tabellen und Diagrammen. Das PDF-Format eignet sich besonders für die Verwendung in gedruckten Publikationen, das PNG-Format besonders für die Darstellung im Internet. Analyst:innen mit fortgeschrittenen Kenntnissen in R können auch auf den Source Code zurückgreifen. Empfohlen für Nutzer:innen die einzelne Inhalte aus dem Codebook für andere Zwecke (z.B. Präsentationen, eigene Publikationen) weiterverwenden möchten.\\


#'\bottomrule

#'\end{longtable}
#'\end{centering}



#+
#'\newpage




#+
#'# Variablen


#+
#'## Datenstruktur 

str(data.corpus)


#+
#'## Hinweise

#'\begin{itemize}
#'\item Fehlende Werte sind immer mit \enquote{NA} codiert
#'\item Strings können grundsätzlich alle in UTF-8 definierten Zeichen (insbesondere Buchstaben, Zahlen und Sonderzeichen) enthalten.
#'\end{itemize}

#+
#'## Erläuterungen zu den einzelnen Variablen

#'\ra{1.3}
#' 
#'\begin{centering}
#'\begin{longtable}{P{3.5cm}P{3cm}p{8cm}}
#' 
#'\toprule
#' 
#'Variable & Typ & Erläuterung\\
#'
#' 
#'\midrule
#'
#'\endhead
#' 
#' doc\_id & String & (Nur CSV-Datei) Der Name der extrahierten TXT-Datei.\\
#' text  & String & (Nur CSV-Datei) Der vollständige Inhalt der Entscheidung, so wie er in der von www.bverwg.de heruntergeladenen PDF-Datei dokumentiert ist. Die einzige editorische Änderung gegenüber den TXT-Dateien ist die Zusammenfügung von über Zeilengrenzen gebrochenen Wörtern.\\
#' gericht & Alphabetisch & In diesem Datensatz ist nur der Wert \mbox{\enquote{BVerwG}} vergeben. Dies ist der ECLI-Gerichtscode für \enquote{\court}. Diese Variable dient vor allem zur einfachen und transparenten Verbindung der Daten mit anderen Datensätzen.\\
#' datum & Datum (ISO) & Das Datum der Entscheidung im Format YYYY-MM-DD (Langform nach ISO-8601). Die Langform ist für Menschen einfacher lesbar und wird maschinell auch öfter automatisch als Datumsformat erkannt.\\
#' entscheidung\_typ & Alphabetisch & Der Typ der Entscheidung. Es sind die Werte \enquote{B} (Beschluss), \enquote{U} (Urteil) und \enquote{G} (Gerichtsbescheid) vergeben.\\
#' spruchkoerper\_az & Natürliche Zahl & Der im Aktenzeichen angegebene Spruchkörper. Es sind die Werte \enquote{1} bis \enquote{10} (Revisions- und Wehrdienstsenate) und \enquote{20} (Fachsenat) vergeben. Die Werte stehen für den jeweiligen Senat des Gerichts. \textbf{Achtung:} die ersten beiden Revisionssenate und die beiden Wehrdienstsenate sind inhaltsgleich mit \enquote{1} und \enquote{2} in den jeweiligen Aktenzeichen codiert. Um zwischen den Revisions- und Wehrdienstsenaten zu unterscheiden müssen Sie in einer Analyse zwingend auch nach dem Registerzeichen differenzieren. Die Registerzeichen der Wehrdienstsenate beginnen immer mit \enquote{W}.\\
#' registerzeichen & String & Das amtliche Registerzeichen. Es gibt die Verfahrensart an, in der die Entscheidung ergangen ist. Eine Erläuterung der Registerzeichen und der zugehörigen Verfahrensarten findet sich unter Punkt \ref{register}.\\
#' verfahrensart & String &  Die ausführliche Beschreibung der Verfahrensart, die dem Registerzeichen zugeordnet ist.  Eine Erläuterung der Registerzeichen und der zugehörigen Verfahrensarten findet sich unter Punkt \ref{register}.\\
#' eingangsnummer & Natürliche Zahl & Verfahren des gleichen Eingangsjahres erhalten vom Gericht eine Nummer in der Reihenfolge ihres Eingangs.\\
#' eingangsjahr\_az & Natürliche Zahl & Das im Aktenzeichen angegebene Jahr in dem das Verfahren beim Gericht anhängig wurde. Das Format ist eine zweistellige Jahreszahl (YY).\\
#' eingangsjahr\_iso & Natürliche Zahl & (Nur CSV-Datei) Das nach ISO-8601 codierte Jahr in dem das Verfahren beim Gericht anhängig wurde. Das Format ist eine vierstellige Jahreszahl (YYYY), um eine maschinenlesbare und eindeutige Jahreszahl für den Eingang zur Verfügung zu stellen. Wurde aus der Variable \enquote{eingangsjahr\_az} durch den Autor des Datensatzes berechnet, unter der Annahme, dass Jahreszahlen über 50 dem 20. Jahrhundert zugeordnet sind und andere Jahreszahlen dem 21. Jahrhundert.\\
#' entscheidungsjahr & Natürliche Zahl & (Nur CSV-Datei) Das Jahr in dem die Entscheidung ergangen ist. Das Format ist eine vierstellige Jahreszahl (YYYY). Wurde aus der Variable \enquote{datum} durch den Autor des Datensatzes berechnet.\\
#' verzoegerung & Alphabetisch & Verzögerungsrügen sind mit \enquote{D} gekennzeichnet. Alle anderen Entscheidungen (der weit überwiegende Anteil) sind mit dem Wert \enquote{NA} codiert.\\
#' kollision & Numerisch & In wenigen Fällen sind am gleichen Tag mehrere Entscheidungen zum gleichen Aktenzeichen ergangen. Diese werden ab der zweiten Entscheidung pro Tag durch eine Kollisions-ID mit einer fortlaufenden Zahl ausdifferenziert. Für die erste Entscheidung ist der Wert der Variable \enquote{0}. Die zweite Entscheidung ist mit \enquote{1} identifiziert, die dritte mit \enquote{2} und so fort.\\
#'praesi & Alphabetisch & (Nur CSV-Datei) Der Nachname des oder der Präsident:in in dessen/deren Amtszeit das Datum der Entscheidung fällt.\\
#'v\_praesi & Alphabetisch & (Nur CSV-Datei) Der Nachname des oder der Vize-Präsident:in in dessen/deren Amtszeit das Datum der Entscheidung fällt.\\
#'aktenzeichen & String & (Nur CSV-Datei) Das amtliche Aktenzeichen. Die Variable wurde aus den Variablen \enquote{spruchkoerper\_az}, \enquote{registerzeichen}, \enquote{eingangsnummer} und \enquote{eingangsjahr\_az} durch den Autor des Datensatzes berechnet.\\
#'ecli & String & (Nur CSV-Datei) Der European Case Law Identifier (ECLI) der Entscheidung. Jeder Entscheidung ist eine einzigartige ECLI zugewiesen. Die ECLI ist vor allem dann hilfreich, wenn dieser Datensatz mit anderen Datensätzen zusammengeführt und Duplikate vermieden werden sollen. Alle inhaltlichen Bestandteile der ECLI sind in diesem Datensatz zusätzlich auch anderen und besser verständlichen Variablen zugewiesen. Nutzen Sie bevorzugt diese anderen Variablen, statt Informationen aus der ECLI zu extrahieren. Die Variable wurde aus den Variablen \enquote{gericht}, \enquote{entscheidungsjahr},  \enquote{datum}, \enquote{entscheidung\_typ},\enquote{spruchkoerper\_az}, \enquote{registerzeichen},  \enquote{eingangsnummer}, \enquote{eingangsjahr\_az}, \enquote{verzoegerung} und \enquote{kollision} durch den Autor des Datensatzes berechnet.\\
#' zeichen & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Zeichen eines Dokumentes.\\
#' tokens & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Tokens (beliebige Zeichenfolge getrennt durch whitespace) eines Dokumentes. Diese Zahl kann je nach Tokenizer und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Tokenisierung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.\\
#' typen & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl \emph{einzigartiger} Tokens (beliebige Zeichenfolge getrennt durch whitespace) eines Dokumentes. Diese Zahl kann je nach Tokenizer und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Tokenisierung und Typenzählung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.\\
#' saetze & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Sätze. Die Definition entspricht in etwa dem üblichen Verständnis eines Satzes. Die Regeln für die Bestimmung von Satzanfang und Satzende sind im Detail allerdings sehr komplex und in \enquote{Unicode Standard: Annex No 29} beschrieben. Diese Zahl kann je nach Software und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Zählung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.\\
#' version & Datum (ISO) & (Nur CSV-Datei) Die Versionsnummer des Datensatzes im Format YYYY-MM-DD (Langform nach ISO-8601). Die Versionsnummer entspricht immer dem Datum an dem der Datensatz erstellt und die Daten von der Webseite des Gerichts abgerufen wurden.\\
#' doi\_concept & String & (Nur CSV-Datei) Der Digital Object Identifier (DOI) des Gesamtkonzeptes des Datensatzes. Dieser ist langzeit-stabil (persistent). Über diese DOI kann via www.doi.org immer die \textbf{aktuellste Version} des Datensatzes abgerufen werden. Prinzip F1 der FAIR-Data Prinzipien (\enquote{data are assigned globally unique and persistent identifiers}) empfiehlt die Dokumentation jeder Messung mit einem persistenten Identifikator. Selbst wenn die CSV-Dateien ohne Kontext weitergegeben werden kann ihre Herkunft so immer zweifelsfrei und maschinenlesbar bestimmt werden.\\
#' doi\_version & String & (Nur CSV-Datei) Der Digital Object Identifier (DOI) der \textbf{konkreten Version} des Datensatzes. Dieser ist langzeit-stabil (persistent). Über diese DOI kann via www.doi.org immer diese konkrete Version des Datensatzes abgerufen werden. Prinzip F1 der FAIR-Data Prinzipien (\enquote{data are assigned globally unique and persistent identifiers}) empfiehlt die Dokumentation jeder Messung mit einem persistenten Identifikator. Selbst wenn die CSV-Dateien ohne Kontext weitergegeben werden kann ihre Herkunft so immer zweifelsfrei und maschinenlesbar bestimmt werden.\\
#' 
#'\bottomrule
#' 
#'\end{longtable}
#'\end{centering}





#'\newpage
#+
#'# Registerzeichen
#' 
#'\label{register}
#'
#' Die Tabelle der Registerzeichen und der ihnen zugeordneten Verfahrensarten stammt aus dem folgenden Datensatz: \enquote{Seán Fobbe (2021). Aktenzeichen der Bundesrepublik Deutschland (AZ-BRD). Version 1.0.1. Zenodo. DOI: 10.5281/zenodo.4569564.}
#'
#' \vspace{0.5cm}


#'\ra{1.2}

kbl(table.registerzeichen[,c(3,5)],
    format = "latex",
    align = c("P{3cm}",
              "p{11cm}"),
    booktabs = TRUE,
    longtable = TRUE,
    col.names = c("Registerzeichen",
                  "Verfahrensart")) 









#'\newpage
#+

#+
#'# Präsident:innen

#+
#'## Hinweise
#' \begin{itemize}
#' \item Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.
#' \item Das Datum bezieht sich jeweils auf das Amt als Präsident:in, nicht auf die Amtszeit als Richter:in.
#' \end{itemize}
#'  

#+
#'## Lebensdaten


kable(table.praesi.daten,
      format = "latex",
      align = "l",
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Nachname",
                    "Vorname",
                    "Amtsantritt",
                    "Amtsende",
                    "Geboren",
                    "Gestorben"))


#'\newpage
#+
#'## Dienstalter und Lebensalter


kable(table.praesi.alter[grep("VACANCY", table.praesi.daten$name_last, invert = TRUE)],
      format = "latex",
      align = c("l", "l", "c", "c", "c"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Nachname",
                    "Vorname",
                    "Alter (Amtsantritt)",
                    "Alter (Amtsende)",
                    "Alter (Tod)"))



#'\newpage
#+
#'# Vize-Präsident:innen

#+
#'## Hinweise
#' \begin{itemize}
#' \item Die Personendaten stammen aus folgendem Datensatz: \enquote{Seán Fobbe and Tilko Swalve (2021). Presidents and Vice-Presidents of the Federal Courts of Germany (PVP-FCG). Version 2021-04-08. Zenodo. DOI: 10.5281/zenodo.4568682}.
#' \item Das Datum bezieht sich jeweils auf das Amt als Vize-Präsident:in, nicht auf die Amtszeit als Richter:in.
#' \end{itemize}


#+
#'## Lebensdaten

kable(table.vpraesi.daten,
      format = "latex",
      align = "l",
      booktabs=TRUE,
      longtable=TRUE,
      col.names = c("Nachname",
                    "Vorname",
                    "Amtsantritt",
                    "Amtsende",
                    "Geboren",
                    "Gestorben"))


#'\newpage
#+
#'##  Dienstalter und Lebensalter


kable(table.vpraesi.alter[grep("VACANCY", table.vpraesi.daten$name_last, invert = TRUE)],
      format = "latex",
      align = c("l", "l", "c", "c", "c"),
      booktabs=TRUE,
      longtable=TRUE,
      col.names = c("Nachname",
                    "Vorname",
                    "Alter (Amtsantritt)",
                    "Alter (Amtsende)",
                    "Alter (Tod)"))







#'\newpage
#+
#'# Linguistische Kennzahlen

#+
#'## Erläuterung der Kennzahlen und Diagramme

#' Zur besseren Einschätzung des inhaltlichen Umfangs des Korpus dokumentiere ich an dieser Stelle die Verteilung der Werte für einige klassische linguistische Kennzahlen.
#'
#' \medskip
#'
#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule

#'Kennzahl & Definition\\

#'\midrule

#' Zeichen & Zeichen entsprechen grob den \emph{Graphemen}, den kleinsten funktionalen Einheiten in einem Schriftsystem. Beispiel: das Wort \enquote{Richterin} besteht aus 9 Zeichen.\\
#' Tokens & Eine beliebige Zeichenfolge, getrennt durch whitespace-Zeichen, d.h. ein Token entspricht in der Regel einem \enquote{Wort}, kann aber auch Zahlen, Sonderzeichen oder sinnlose Zeichenfolgen enthalten, weil es rein syntaktisch berechnet wird.\\
#' Typen & Einzigartige Tokens. Beispiel: wenn das Token \enquote{Verfassungsrecht} zehnmal in einer Entscheidung vorhanden ist, wird es als ein Typ gezählt.\\
#' Sätze & Entsprechen in etwa dem üblichen Verständnis eines Satzes. Die Regeln für die Bestimmung von Satzanfang und Satzende sind im Detail aber sehr komplex und in \enquote{Unicode Standard: Annex No 29} beschrieben.\\

#'\bottomrule

#'\end{longtable}
#'\end{centering}
#'
#' Es handelt sich bei den Diagrammen jeweils um "Density Charts", die sich besonders dafür eignen die Schwerpunkte von Variablen mit stark schwankenden numerischen Werten zu visualisieren. Die Interpretation ist denkbar einfach: je höher die Kurve, desto dichter sind in diesem Bereich die Werte der Variable. Der Wert der y-Achse kann außer Acht gelassen werden, wichtig sind nur die relativen Flächenverhältnisse und die x-Achse.
#'
#' Vorsicht bei der Interpretation: Die x-Achse it logarithmisch skaliert, d.h. in 10er-Potenzen und damit nicht-linear. Die kleinen Achsen-Markierungen zwischen den Schritten der Exponenten sind eine visuelle Hilfestellung um diese nicht-Linearität zu verstehen.
#'
#'\bigskip

#'## Werte der Kennzahlen

setnames(stats.ling, c("Variable",
                       "Summe",
                       "Min",
                       "Quart1",
                       "Median",
                       "Mittel",
                       "Quart3",
                       "Max"))

kable(stats.ling,
      digits = 2,
      format.args = list(big.mark = ","),
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)




#+
#'## Verteilung Zeichen

#+ CE-BVerwG_09_Density_Zeichen, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus)+
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
        caption = paste("DOI:",
                        doi.version),
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


#'## Verteilung Tokens

#+ CE-BVerwG_10_Density_Tokens, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus)+
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
        caption = paste("DOI:",
                        doi.version),
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


#'## Verteilung Typen

#+ CE-BVerwG_11_Density_Typen, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus)+
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
        caption = paste("DOI:",
                        doi.version),
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


#'## Verteilung Sätze

#+ CE-BVerwG_12_Density_Saetze, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus)+
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
        caption = paste("DOI:",
                        doi.version),
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




    
#' \newpage
#' \ra{1.4}
#+
#'# Inhalt des Korpus

#+
#'## Zusammenfassung

setnames(stats.docvars, c("Variable",
                          "Anzahl",
                          "Min",
                          "Quart1",
                          "Median",
                          "Mittel",
                          "Quart3",
                          "Max"))


kable(stats.docvars,
      digits = 2,
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)


#'\vspace{1cm}

#'## Nach Typ der Entscheidung

freqtable <- table.entsch.typ[-.N]

#'\vspace{0.5cm}

#+ CE-BVerwG_02_Barplot_Entscheidungstyp, fig.height = 5, fig.width = 8
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
        caption = paste("DOI:",
                        doi.version),
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



#'\vspace{1cm}

kable(table.entsch.typ,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Typ",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ"))



#+
#'## Nach Spruchkörper (Aktenzeichen)


#'\vspace{0.5cm}
freqtable <- table.spruch.az[-.N][,lapply(.SD, as.numeric)]


#+ CE-BVerwG_03_Barplot_Spruchkoerper_AZ, fig.height = 5, fig.width = 8
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
        caption = paste("DOI:",
                        doi.version),
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



#'\vspace{1cm}

kable(table.spruch.az[order(as.numeric(spruchkoerper_az))],
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Senat",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ")) %>% kable_styling(latex_options = "repeat_header")





#'## Nach Registerzeichen

#'\vspace{0.5cm}
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
        caption = paste("DOI:",
                        doi.version),
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

kable(table.regz,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Registerzeichen",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ"))  %>% kable_styling(latex_options = "repeat_header")


#'\newpage
#'## Nach Präsident:in

#'\vspace{0.5cm}
freqtable <- table.output.praesi[-.N]

#+ CE-BVerwG_05_Barplot_PraesidentIn, fig.height = 5.5, fig.width = 8
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
        caption = paste("DOI:",
                        doi.version),
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


#'\vspace{0.5cm}

kable(table.output.praesi,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Präsident:in",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ"))  %>% kable_styling(latex_options = "repeat_header")


#'\newpage
#'## Nach Vize-Präsident:in

#'\vspace{0.5cm}
freqtable <- table.output.vpraesi[-.N]


#+ CE-BVerwG_06_Barplot_VizePraesidentIn, fig.height = 5.5, fig.width = 8
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
        caption = paste("DOI:",
                        doi.version),
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


#'\vspace{0.5cm}

kable(table.output.vpraesi,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Vize-Präsident:in",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ"))  %>% kable_styling(latex_options = "repeat_header")






#' \newpage
#+
#'## Nach Entscheidungsjahr

#'\vspace{0.5cm}
freqtable <- table.jahr.entscheid[-.N][,lapply(.SD, as.numeric)]

#+ CE-BVerwG_07_Barplot_Entscheidungsjahr, fig.height = 7, fig.width = 11
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
        caption = paste("DOI:",
                        doi.version),
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

#'\vspace{1cm}

kable(table.jahr.entscheid,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Jahr",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ"))  %>% kable_styling(latex_options = "repeat_header")




#'\newpage
#+
#'## Nach Eingangsjahr (ISO)


#'\vspace{0.5cm}


freqtable <- table.jahr.eingangISO[-.N][,lapply(.SD, as.numeric)]


#+ CE-BVerwG_08_Barplot_EingangsjahrISO, fig.height = 7, fig.width = 11
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
        caption = paste("DOI:",
                        doi.version),
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

#'\vspace{1cm}

kable(table.jahr.eingangISO,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Jahr",
                    "Entscheidungen",
                    "% Gesamt",
                    "% Kumulativ"))  %>% kable_styling(latex_options = "repeat_header")





#'# Dateigrößen

#+
#'## Verteilung PDF

#' ![](ANALYSE/CE-BVerwG_13_Density_Dateigroessen_PDF-1.pdf)


#+
#'## Verteilung TXT
#' ![](ANALYSE/CE-BVerwG_14_Density_Dateigroessen_TXT-1.pdf)

#'\newpage

#+
#'## Gesamtgröße je ZIP-Archiv
files.zip <- fread(hashfile)$filename
filesize <- round(file.size(files.zip) / 10^6, digits = 2)

table.size <- data.table(files.zip,
                         filesize)


kable(table.size,
      format = "latex",
      align = c("l", "r"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Datei",
                    "Größe in MB"))



#'\newpage
#+
#'# Prüfung kryptographischer Signaturen

#+
#'## Allgemeines
#' Die Integrität und Echtheit der einzelnen Archive des Datensatzes sind durch eine Zwei-Phasen-Signatur sichergestellt.
#'
#' In **Phase I** werden während der Kompilierung für jedes ZIP-Archiv Hash-Werte in zwei verschiedenen Verfahren (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei dokumentiert.
#'
#' In **Phase II** wird diese CSV-Datei mit meinem persönlichen geheimen GPG-Schlüssel signiert. Dieses Verfahren stellt sicher, dass die Kompilierung von jedermann durchgeführt werden kann, insbesondere im Rahmen von Replikationen, die persönliche Gewähr für Ergebnisse aber dennoch vorhanden bleibt.
#'
#' Dieses Codebook ist vollautomatisch erstellt und prüft die kryptographisch sicheren SHA3-512 Signaturen (\enquote{hashes}) aller ZIP-Archive, sowie die GPG-Signatur der CSV-Datei, welche die SHA3-512 Signaturen enthält. SHA3-512 Signaturen werden durch einen system call zur OpenSSL library auf Linux-Systemen berechnet. Eine erfolgreiche Prüfung meldet \enquote{Signatur verifiziert!}. Eine gescheiterte Prüfung meldet \enquote{FEHLER!}

#+
#'## Persönliche GPG-Signatur
#' Die während der Kompilierung des Datensatzes erstellte CSV-Datei mit den Hash-Prüfsummen ist mit meiner persönlichen GPG-Signatur versehen. Der mit dieser Version korrespondierende Public Key ist sowohl mit dem Datensatz als auch mit dem Source Code hinterlegt. Er hat folgende Kenndaten:
#' 
#' **Name:** Sean Fobbe (fobbe-data@posteo.de)
#' 
#' **Fingerabdruck:** FE6F B888 F0E5 656C 1D25  3B9A 50C4 1384 F44A 4E42

#+
#'## Import: Public Key
#+ echo = TRUE
system2("gpg2", "--import GPG-Public-Key_Fobbe-Data.asc",
        stdout = TRUE,
        stderr = TRUE)




#'\newpage
#+
#'## Prüfung: GPG-Signatur der Hash-Datei

#+ echo = TRUE

# CSV-Datei mit Hashes
print(hashfile)
# GPG-Signatur
print(signaturefile)

# GPG-Signatur prüfen
testresult <- system2("gpg2",
                      paste("--verify", signaturefile, hashfile),
                      stdout = TRUE,
                      stderr = TRUE)

# Anführungsstriche entfernen um Anzeigefehler zu vermeiden
testresult <- gsub('"', '', testresult)

#+ echo = TRUE
kable(testresult, format = "latex", booktabs = TRUE,
      longtable = TRUE, col.names = c("Ergebnis"))


#'\newpage
#+
#'## Prüfung: SHA3-512 Hashes der ZIP-Archive
#+ echo = TRUE

# Prüf-Funktion definieren
sha3test <- function(filename, sig){
    sig.new <- system2("openssl",
                       paste("sha3-512", filename),
                       stdout = TRUE)
    sig.new <- gsub("^.*\\= ", "", sig.new)
    if (sig == sig.new){
        return("Signatur verifiziert!")
    }else{
        return("FEHLER!")
    }
}


# Ursprüngliche Signaturen importieren
table.hashes <- fread(hashfile)
filename <- table.hashes$filename
sha3.512 <- table.hashes$sha3.512

# Signaturprüfung durchführen 
sha3.512.result <- mcmapply(sha3test, filename, sha3.512, USE.NAMES = FALSE)

# Ergebnis anzeigen
testresult <- data.table(filename, sha3.512.result)

#+ echo = TRUE
kable(testresult, format = "latex", booktabs = TRUE,
      longtable = TRUE, col.names = c("Datei", "Ergebnis"))




#+
#'# Changelog
#'
#'\ra{1.3}
#'
#' 
#'\begin{centering}
#'\begin{longtable}{p{2.5cm}p{11.5cm}}
#'\toprule
#'Version &  Details\\
#'\midrule
#'
#' \version  &
#'
#' \begin{itemize}
#' \item Vollständige Aktualisierung der Daten
#' \item Veröffentlichung des vollständigen Source Codes
#' \item Deutliche Erweiterung des inhaltlichen Umfangs des Codebooks
#' \item Einführung der vollautomatischen Erstellung von Datensatz und Codebook
#' \item Einführung von Compilation Reports um den Erstellungsprozess exakt zu dokumentieren
#' \item Einführung von Variablen für Versionsnummer, Concept DOI, Version DOI, ECLI, Präsident:in, Vize-Präsident:in, Verfahrensart und linguistische Kennzahlen (Zeichen, Tokens, Typen, Sätze)
#' \item Zusammenfügung von über Zeilengrenzen getrennten Wörtern
#' \item Automatisierung und Erweiterung der Qualitätskontrolle
#' \item Einführung von Diagrammen zur Visualisierung von Prüfergebnissen
#' \item Einführung kryptographischer Signaturen
#' \item Variable \enquote{Suffix} in \enquote{kollision} umbenannt.
#' \item Variable \enquote{Ordinalzahl} in \enquote{eingangsnummer} umbenannt.
#' \item Variable \enquote{Entscheidungsart} in \enquote{entscheidung\_typ} umbenannt.
#' \item Alle übrigen Variablen sind nun in Kleinschreibung und Snake Case gehalten

#' \end{itemize}\\
#' 
#' 
#'2020-06-23  &
#'
#' \begin{itemize}
#' \item Erstveröffentlichung
#' \end{itemize}\\
#' 
#'\bottomrule
#'\end{longtable}
#'\end{centering}

#'\newpage
#+
#'# Parameter für strenge Replikationen

system2("openssl",  "version", stdout = TRUE)

sessionInfo()

#'# Literaturverzeichnis
