#'# f.dopar.spacyparse
#' Iterated parallel computation of linguistic annotations via spacy.


#' @param x A data table. Must have variables "doc_id" and "text".



f.future_spacyparse <- function(x,
                                chunksperworker = 1,
                                chunksize = NULL,
                                model = "en_core_web_sm",
                                pos = TRUE,
                                tag = FALSE,
                                lemma = FALSE,
                                entity = FALSE,
                                dependency = FALSE,
                                nounphrase = FALSE,
                                multicore = TRUE,
                                cores = parallel::detectCores()){


    ## Begin Profiling
    begin <- Sys.time()


    ## Initalize Model
    spacy_initialize(model = model)

    

    ## Set Future Strategy
    if(multicore == TRUE){

        plan("multicore",
             workers = cores)
        
    }else{

        plan("sequential")

    }


    

    ## Run Annottions
    raw.list <- split(x, seq(nrow(x)))
    
    result.list <- future_lapply(raw.list,
                                 spacy_parse,
                                 future.seed = TRUE,
                                 future.scheduling = chunksperworker,
                                 future.chunk.size = chunksize,
                                 pos = pos,
                                 tag = tag,
                                 lemma = lemma,
                                 entity = entity,
                                 dependency = dependency,
                                 nounphrase = nounphrase,
                                 multithread = FALSE)
    
    dt.return <- rbindlist(result.list)
    
    
    

    ## Report Profiling
    end <- Sys.time()
    duration <- end - begin

    print(paste0("Runtime was ",
                 round(duration,
                       digits = 2),
                 " ",
                 attributes(duration)$units,
                 ". Ended at ",
                 end, "."))


    ## Close Spacy Connection
    spacy_finalize()

    
    return(dt.return)


}
