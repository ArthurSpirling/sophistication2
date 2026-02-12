#' Compute covariates for sophistication analysis
#'
#' Computes various text features as covariates for sophistication analysis.
#' @param x a \link[quanteda:corpus]{quanteda::corpus} object or character vector
#' @param baseline optional baseline data for normalization
#' @param normalize if \code{TRUE}, normalize features
#' @return a data.frame of covariates
#' @export
#' @import quanteda
#' @examples
#' \dontrun{
#' txt <- c("This is a simple sentence.", 
#'          "This is a more complex sentence with additional words.")
#' covars_make(txt)
#' }
covars_make <- function(x, baseline = NULL, normalize = FALSE) {
    
    # Convert to corpus
    if (!inherits(x, "corpus")) {
        x <- quanteda::corpus(x)
    }
    
    # Tokenize
    toks <- quanteda::tokens(x)
    
    # Basic features
    n_tokens <- quanteda::ntoken(toks)
    n_types <- quanteda::ntype(toks)
    ttr <- n_types / n_tokens
    
    # Average word length
    tok_texts <- unlist(quanteda::as.list(toks))
    avg_word_length <- mean(nchar(tok_texts), na.rm = TRUE)
    
    # Sentence length statistics
    corp_sent <- quanteda::corpus_reshape(x, to = "sentences")
    sent_lengths <- quanteda::ntoken(quanteda::tokens(corp_sent))
    avg_sent_length <- mean(sent_lengths, na.rm = TRUE)
    
    # Build result data.frame
    result <- data.frame(
        n_tokens = n_tokens,
        n_types = n_types,
        ttr = ttr,
        avg_word_length = avg_word_length,
        avg_sent_length = avg_sent_length,
        stringsAsFactors = FALSE
    )
    
    # Normalize if requested
    if (normalize && !is.null(baseline)) {
        for (col in names(result)) {
            if (is.numeric(result[[col]]) && col %in% names(baseline)) {
                result[[col]] <- (result[[col]] - baseline[[col]]$mean) / baseline[[col]]$sd
            }
        }
    }
    
    return(result)
}


#' Compute baseline covariates
#'
#' Computes mean and standard deviation of covariates for normalization.
#' @param x a \link[quanteda:corpus]{quanteda::corpus} object or character vector
#' @param reference_year optional reference year for temporal normalization
#' @return a list of baseline statistics
#' @export
covars_make_baselines <- function(x, reference_year = NULL) {
    
    # Get covariates
    covars <- covars_make(x, normalize = FALSE)
    
    # Compute baselines
    baseline <- list()
    for (col in names(covars)) {
        if (is.numeric(covars[[col]])) {
            baseline[[col]] <- list(
                mean = mean(covars[[col]], na.rm = TRUE),
                sd = sd(covars[[col]], na.rm = TRUE),
                median = median(covars[[col]], na.rm = TRUE)
            )
        }
    }
    
    return(baseline)
}
