#' Compute bootstrapped readability statistics
#'
#' Function to compute bootstrapped mean and SEs for readability statistics.
#' This is a wrapper around \code{\link[quanteda.textstats:textstat_readability]{quanteda.textstats::textstat_readability()}}, that redraws the corpus
#' using sentence-level bootstrapping from the sentences found in the corpus.
#'
#' @param x a character or \link[quanteda:corpus]{quanteda::corpus} object
#' @param measure readability measure to compute (passed to \code{\link[quanteda.textstats:textstat_readability]{quanteda.textstats::textstat_readability()}})
#' @param n number of bootstrap iterations
#' @param ...additional arguments passed to \code{\link[quanteda.textstats:textstat_readability]{quanteda.textstats::textstat_readability()}}
#' @param verbose if \code{TRUE} show status messages
#' @return a named list with \code{mean} and \code{se} elements containing the bootstrap mean and standard error  
#' @export
#' @importFrom quanteda.textstats textstat_readability
#' @import quanteda
#' @examples
#' \dontrun{
#' txt <- c("This is a simple sentence.", 
#'          "This sentence is more complex with additional clauses.",
#'          "Short text.")
#' bootstrap_readability(txt, measure = "Flesch", n = 10)
#' }
bootstrap_readability <- function(x, measure = "Flesch", n = 100, ..., verbose = TRUE) {
    
    # Convert to corpus if needed
    if (is.character(x)) {
        x <- quanteda::corpus(x)
    }
    
    # Segment corpus into sentences
    corp_sent <- quanteda::corpus_reshape(x, to = "sentences")
    
    # Number of sentences
    n_sent <- quanteda::ndoc(corp_sent)
    
    if (verbose) {
        cat("Computing", n, "bootstrap iterations from", n_sent, "sentences...\n")
    }
    
    # Bootstrap loop
    boot_results <- numeric(n)
    for (i in 1:n) {
        # Resample sentences with replacement
        sent_sample <- sample(1:n_sent, size = n_sent, replace = TRUE)
        corp_boot <- quanteda::corpus_subset(corp_sent, quanteda::docid(corp_sent) %in% quanteda::docid(corp_sent)[sent_sample])
        
        # Reshape back to documents (one document per original doc)
        # For bootstrap, we just combine all sampled sentences
        corp_boot_doc <- quanteda::corpus_reshape(corp_boot, to = "documents")
        
        # Compute readability
        read_stat <- quanteda.textstats::textstat_readability(corp_boot_doc, measure = measure, ...)
        
        # Store mean readability
        boot_results[i] <- mean(read_stat[[measure]], na.rm = TRUE)
        
        if (verbose && i %% 10 == 0) {
            cat("  Completed", i, "of", n, "iterations\n")
        }
    }
    
    if (verbose) {
        cat("...finished.\n")
    }
    
    # Return bootstrap statistics
    list(
        mean = mean(boot_results, na.rm = TRUE),
        se = sd(boot_results, na.rm = TRUE),
        boot_values = boot_results
    )
}
