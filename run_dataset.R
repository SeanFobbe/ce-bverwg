# Run full data set pipeline

dir.create("output", showWarnings = FALSE)

rmarkdown::render("CE-BVerwG_Compilation.Rmd",
                  output_file = paste0("output/CE-BVerwG_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"))

