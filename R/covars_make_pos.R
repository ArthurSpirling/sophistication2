#' Compute part-of-speech covariates
#'
#' Computes part-of-speech features using spacyr (if available).
#' This function requires the spacyr package and a working spaCy installation.
#' @param x a \link[quanteda:corpus]{quanteda::corpus} object or character vector
#' @param pos_tags character vector of POS tags to count (default: common tags)
#' @param normalize if \code{TRUE}, compute proportions rather than counts
#' @return a data.frame of POS covariates
#' @export
#' @examples
#' \dontrun{
#' # Requires spacyr and spaCy to be installed
#' if (requireNamespace("spacyr", quietly = TRUE)) {
#'   library(spacyr)
#'   spacy_initialize()
#'   txt <- c("This is a simple sentence.", 
#'            "This is a more complex sentence.")
#'   covars_make_pos(txt)
#'   spacy_finalize()
#' }
#' }
covars_make_pos <- function(x, 
                           pos_tags = c("ADJ", "ADV", "NOUN", "VERB", "ADP", "DET"),
                           normalize = TRUE) {
    
    # Check if spacyr is available
    if (!requireNamespace("spacyr", quietly = TRUE)) {
        stop("The spacyr package is required for POS analysis. Install it with:\n",
             "  install.packages('spacyr')\n",
             "  library(spacyr)\n",
             "  spacy_install()\n",
             "See: https://cran.r-project.org/web/packages/spacyr/")
    }
    
    # Check if spaCy is initialized
    if (!spacyr::spacy_is_installed()) {
        stop("spaCy must be installed. Run:\n",
             "  library(spacyr)\n",
             "  spacy_install()")
    }
    
    # Convert to character if needed
    if (inherits(x, "corpus")) {
        x <- as.character(x)
    }
    
    # Parse with spaCy
    parsed <- spacyr::spacy_parse(x)
    
    # Count POS tags for each document
    result <- data.frame(doc_id = unique(parsed$doc_id), stringsAsFactors = FALSE)
    
    for (tag in pos_tags) {
        counts <- tapply(parsed$pos == tag, parsed$doc_id, sum)
        result[[paste0("pos_", tag)]] <- as.numeric(counts[result$doc_id])
    }
    
    # Normalize to proportions if requested
    if (normalize) {
        doc_lengths <- tapply(rep(1, nrow(parsed)), parsed$doc_id, sum)
        for (tag in pos_tags) {
            col_name <- paste0("pos_", tag)
            result[[col_name]] <- result[[col_name]] / as.numeric(doc_lengths[result$doc_id])
        }
    }
    
    return(result)
}
