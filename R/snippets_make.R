#' Create text snippets from a corpus
#'
#' Creates snippets of n-length sentences from a corpus, with minimum and maximum character lengths.
#' @param x a \link[quanteda:corpus]{quanteda::corpus} object
#' @param nsentence number of sentences per snippet
#' @param minchar minimum number of characters per snippet
#' @param maxchar maximum number of characters per snippet
#' @return a data.frame with columns: docID, snippetID, and text
#' @export
#' @import quanteda
#' @examples
#' \dontrun{
#' library(quanteda)
#' corp <- corpus(c(d1 = "This is sentence one. This is sentence two. Sentence three here.", 
#'                  d2 = "Another document. With multiple sentences. To test with."))
#' snippets_make(corp, nsentence = 1, minchar = 10, maxchar = 50)
#' }
snippets_make <- function(x, nsentence = 1, minchar = 0, maxchar = Inf) {
    
    # Convert to corpus if needed
    if (!inherits(x, "corpus")) {
        x <- quanteda::corpus(x)
    }
    
    # Get document IDs
    doc_ids <- quanteda::docnames(x)
    
    # Segment into sentences
    corp_sent <- quanteda::corpus_reshape(x, to = "sentences")
    
    # Get texts and metadata
    sent_texts <- as.character(corp_sent)
    sent_docids <- quanteda::docid(corp_sent)
    
    # Initialize result list
    result_list <- list()
    snippet_counter <- 1
    
    # For each document
    for (doc in doc_ids) {
        # Get sentences for this document
        doc_sents <- sent_texts[sent_docids == doc]
        
        if (length(doc_sents) < nsentence) {
            next
        }
        
        # Create snippets by sliding window
        n_snippets <- length(doc_sents) - nsentence + 1
        
        for (i in 1:n_snippets) {
            # Get sentences for this snippet
            snippet_sents <- doc_sents[i:(i + nsentence - 1)]
            snippet_text <- paste(snippet_sents, collapse = " ")
            
            # Check character length
            nchar_snippet <- nchar(snippet_text)
            if (nchar_snippet >= minchar && nchar_snippet <= maxchar) {
                result_list[[snippet_counter]] <- data.frame(
                    docID = doc,
                    snippetID = paste0(doc, "_", sprintf("%07d", snippet_counter)),
                    text = snippet_text,
                    stringsAsFactors = FALSE
                )
                snippet_counter <- snippet_counter + 1
            }
        }
    }
    
    # Combine into data.frame
    if (length(result_list) > 0) {
        result_df <- do.call(rbind, result_list)
        rownames(result_df) <- NULL
        return(result_df)
    } else {
        return(data.frame(docID = character(), 
                         snippetID = character(), 
                         text = character(), 
                         stringsAsFactors = FALSE))
    }
}
