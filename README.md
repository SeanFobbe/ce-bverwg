[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4625134.svg)](https://doi.org/10.5281/zenodo.4625134)

# Überblick

Dieses Skript in der Programmiersprache 'R' lädt alle auf www.bverwg.de veröffentlichten Entscheidungen des Bundesverwaltungsgerichts (BVerwG) herunter und kompiliert sie in einen reichhaltigen menschen- und maschinenlesbaren Korpus. Es ist die Basis für den Corpus der Entscheidungen des Bundesverwaltungsgerichts (CE-BVerwG).

Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Jede Version ist mit ihrem eigenen, persistenten Digital Object Identifier (DOI) versehen. Die neueste Version des Datensatzes ist immer über den Link der Concept DOI erreichbar: https://doi.org/10.5281/zenodo.3911067

 

# Aktualisierung

Diese Software wird ca. alle 6 Monate aktualisiert. Benachrichtigungen über neue und aktualisierte Datensätze veröffentliche ich immer zeitnah auf Twitter unter @FobbeSean.

 

# Systemanforderungen

Das Skript in seiner veröffentlichten Form kann nur unter Linux ausgeführt werden, da es Linux-spezifische Optimierungen (z.B. Fork Cluster) und Shell-Kommandos (z.B. OpenSSL) nutzt. Das Skript wurde unter Fedora Linux entwickelt und getestet. Die zur Kompilierung benutzte Version entnehmen Sie bitte dem sessionInfo()-Ausdruck am Ende des Compilation Reports.

In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Wenn die Anzahl Threads (Variable »fullCores«) auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.

Auf der Festplatte sollten 6 GB Speicherplatz vorhanden sein. Wenn linguistische Annotationen erstellt werden steigen die Anforderungen auf ca. 12 GB Speicherplatz und 64 GB Arbeitsspeicher sind notwendig um die Berechnungen auf 16 Cores durchzuführen.

Um die PDF-Berichte kompilieren zu können benötigen Sie das R package rmarkdown, eine vollständige Installation von LaTeX und alle in der Präambel-TEX-Datei angegebenen LaTeX Packages.

 

# Kompilierung: Vorbemerkungen

Mit der Funktion render() von rmarkdown können der vollständige Datensatz und das Codebook kompiliert und die Skripte mitsamt ihrer Rechenergebnisse in ein gut lesbares PDF-Format überführt werden.

Alle Kommentare sind im roxygen2-Stil gehalten. Das Skript kann daher auch ohne render() regulär als R-Skript ausgeführt werden. Es wird in diesem Fall kein PDF-Bericht erstellt und Diagramme werden nicht abgespeichert.

 

# Kompilierung: Datensatz

Um den vollständigen Datensatz zu kompilieren und einen PDF-Bericht zu erstellen, kopieren Sie bitte alle im Source-Archiv bereitgestellten Dateien in einen leeren Ordner und führen mit R diesen Befehl aus:

```R

rmarkdown::render(input = "CE-BVerwG_Source_CorpusCreation.R",
                  output_file = paste0("CE-BVerwG_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"),
                  envir = new.env())
```
 

# Kompilierung: Codebook

Um das Codebook zu kompilieren und einen PDF-Bericht zu erstellen, führen Sie bitte im Anschluss an die Kompilierung des Datensatzes (!) untenstehenden Befehl mit R aus.

Bei der Prüfung der GPG-Signatur wird ein Fehler auftreten und im Codebook dokumentiert, weil die Daten nicht mit meiner Original-Signatur versehen sind. Dieser Fehler hat jedoch keine Auswirkungen auf die Funktionalität und hindert die Kompilierung nicht.

 
```R
rmarkdown::render(input = "CE-BVerwG_Source_CodebookCreation.R",
                  output_file = paste0("CE-BVerwG_",
                                       Sys.Date(),
                                       "_Codebook.pdf"),
                  envir = new.env())
```



# Weitere Open Access Veröffentlichungen (Fobbe)

Website — www.seanfobbe.de

Open Data  —  [zenodo.org/communities/sean-fobbe-data/](zenodo.org/communities/sean-fobbe-data/)

Source Code  —  [zenodo.org/communities/sean-fobbe-code/](zenodo.org/communities/sean-fobbe-code/)

Volltexte regulärer Publikationen  —  [zenodo.org/communities/sean-fobbe-publications/](zenodo.org/communities/sean-fobbe-publications/)



# Disclaimer

Dieser Datensatz ist eine private wissenschaftliche Initiative und steht weder mit dem Bundesverwaltungsgericht noch mit den Herausgebern der BVerwGE in Verbindung.
