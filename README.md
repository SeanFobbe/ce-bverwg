# README: Corpus der Entscheidungen des Bundesverwaltungsgerichts (CE-BVerwG)


## Überblick

Das **Corpus der Entscheidungen des Bundesverwaltungsgerichts (CE-BVerwG)** ist eine möglichst vollständige Sammlung der vom Bundesverwaltungsgericht veröffentlichten Entscheidungen. Der Datensatz nutzt als seine Datenquelle die Entscheidungsdatenbank des Bundesverwaltungsgerichts und wertet diese vollständig aus.

Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Alle Versionen sind mit einem separaten und langzeit-stabilen (persistenten) Digital Object Identifier (DOI) versehen.

Aktuellster, funktionaler und zitierfähiger Release des Datensatzes: https://doi.org/10.5281/zenodo.3911067



## Funktionsweise

Primäre Endprodukte des Skripts sind folgende ZIP-Archive:
 
- Der volle Datensatz im CSV-Format
- Die reinen Metadaten im CSV-Format (wie unter 1, nur ohne Entscheidungstexte)
- Alle Entscheidungen im TXT-Format (reduzierter Umfang an Metadaten)
- Alle Entscheidungen im PDF-Format (reduzierter Umfang an Metadaten)
- Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)
- Der Source Code und alle weiteren Quelldaten

Alle Ergebnisse werden im Ordner 'output' abgelegt. Zusätzlich werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. 


## Systemanforderungen

- Nur mit Fedora Linux getestet. Vermutlich auch funktionsfähig unter anderen Linux-Distributionen.
- 16 GB Speicherplatz auf Festplatte
- Multi-core CPU empfohlen (8 cores/16 threads für die Referenzdatensätze). 


In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System zu nutzen. Die Anzahl der verwendeten Kerne kann in der Konfigurationsatei angepasst werden. Wenn die Anzahl Threads auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.



## Anleitung


### Schritt 1: Ordner vorbereiten

Kopieren Sie bitte den gesamten Source Code in einen leeren Ordner (!), beispielsweise mit:

```
git clone https://github.com/seanfobbe/ce-bverwg
```

Verwenden Sie immer einen eigenständigen und *leeren* Ordner für die Kompilierung. Die Skripte löschen innerhalb von bestimmten Unterordnern (`txt/`, `pdf/`, `temp/`, `analysis` und `output/`) alle Dateien die den Datensatz verunreinigen könnten --- aber auch nur dort.



### Schritt 2: Installation der Programmiersprache 'R'

Sie müssen die [Programmiersprache R](https://www.r-project.org/) installiert haben.





### Schritt 3: Installation von 'renv'

Starten sie eine R Session in diesem Ordner, sie sollten automatisch zur Installation von [renv](https://rstudio.github.io/renv/articles/renv.html) (Tool zur Versionierung von R packages) aufgefordert werden.





### Schritt 4: Installation von R Packages

Um alle packages in der benötigten Version zu installieren, führen Sie in der R session aus:

```
renv::restore()  # In einer R-Konsole ausführen
```

*Achtung:* es reicht nicht, die Packages auf herkömmliche Art installiert zu haben. Sie müssen dies nochmal über [renv](https://rstudio.github.io/renv/articles/renv.html) tun, selbst wenn die Packages in ihrer normalen Library schon vorhanden sind.


### Schritt 5: Installation von Spacy

Spacy (eine Python library) muss separat installiert werden. `spacyr` übernimmt dies für sie automatisch:

```
spacyr::spacy_install(lang_models = "de_core_news_sm")  # In einer R-Konsole ausführen
```

Wenn sie spacy bereits in dem Conda environment `spacy_condaenv` installiert haben, ist es ausreichend wenn sie das deutsche language model `de_core_news_sm` installieren.


### Schritt 6: Installation von LaTeX

Um die PDF Reports zu kompilieren benötigen Sie eine \LaTeX -Installation. Sie können eine vollständige \LaTeX -Distribution auf Fedora wie folgt installieren:

```
sudo dnf install texlive-scheme-full
```

Alternativ können sie das R package [tinytex](https://yihui.org/tinytex/) installieren, welches nur die benötigten \LaTeX\ packages installiert.

```
install.packages("tinytex")  # In einer R-Konsole ausführen
```

Die für die Referenzdatensätze verwendete \LaTeX -Installation ist `texlive-scheme-full`.





### Schritt 7: Datensatz kompilieren

Den vollständigen Datensatz kompilieren Sie mit folgendem Befehl:

```
source("run_dataset.R") # In einer R-Konsole ausführen
```



### Ergebnis

Der Datensatz und alle weiteren Ergebnisse sind nun im Ordner `output/` abgelegt.





## Pipeline visualisieren

Sie können die Pipeline visualisieren, aber nur nachdem sie die zentrale .Rmd-Datei mindestens einmal gerendert haben:

```
targets::tar_glimpse()     # Nur Datenobjekte
targets::tar_visnetwork()  # Alle Objekte
```





## Troubleshooting

Hilfreiche Befehle um Fehler zu lokalisieren und zu beheben.

```
tar_progress()  # Zeigt Fortschritt und Fehler an
tar_meta()      # Metadaten inspizieren
tar_meta(fields = "warnings", complete_only = TRUE)  # Targets mit Warnungen
tar_meta(fields = "error", complete_only = TRUE)  # Targets mit Fehlermeldungen
tar_meta(fields = "seconds")  # Laufzeit der Targets
```





## Projektstruktur

Die folgende Struktur erläutert die wichtigsten Bestandteile des Projekts. Währen der Kompilierung werden weitere Ordner erstellt (`pdf/`, `txt/`, `temp/` `analysis` und `output/`). Die Endergebnisse werden alle in `output/` abgelegt.

 
``` 
├── pipeline.Rmd               # Zentrale Definition der Pipeline
├── config.toml                # Zentrale Konfigurations-Datei
├── R-fobbe-proto-package      # Oft verwendete Funktionen 
├── _targets_packages.R        # Automatisiert erstellte Package-Liste für renv
├── buttons                    # Buttons (nur optische Bedeutung)
├── data                       # Datensätze, auf denen die Pipeline aufbaut
├── functions                  # Wichtige Schritte der Pipeline
├── gpg                        # Persönlicher Public GPG-Key für Seán Fobbe
├── renv                       # Versionskontrolle: Executables
├── renv.lock                  # Versionskontrolle: Versionsinformationen
├── reports                    # Markdown-Dateien
└── tex                        # LaTeX-Templates

```




 
## Weitere Open Access Veröffentlichungen (Fobbe)

Website — https://www.seanfobbe.de

Open Data  —  https://zenodo.org/communities/sean-fobbe-data/

Source Code  —  https://zenodo.org/communities/sean-fobbe-code/

Volltexte regulärer Publikationen  —  https://zenodo.org/communities/sean-fobbe-publications/



## Kontakt

Fehler gefunden? Anregungen? Kommentieren Sie gerne im Issue Tracker auf GitHub oder schreiben Sie mir eine E-Mail an [fobbe-data@posteo.de](fobbe-data@posteo.de)
