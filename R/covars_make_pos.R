#' Compute part-of-speech covariates
#'
#' Computes part-of-speech features using udpipe (pure R, no Python required).
#' On first use, this will download the English language model (~17MB).
#' @param x a \link[quanteda:corpus]{quanteda::corpus} object or character vector
#' @param pos_tags character vector of POS tags to count (default: common tags).
#'   Uses Universal Dependencies tagset: ADJ, ADV, NOUN, VERB, ADP, DET, etc.
#' @param normalize if \code{TRUE}, compute proportions rather than counts
#' @param model_language language model to use (default: "english-ewt")
#' @return a data.frame of POS covariates
#' @export
#' @import udpipe
#' @examples
#' \dontrun{
#' txt <- c("This is a simple sentence.", 
#'          "This is a more complex sentence.")
#' # First use downloads the model automatically
#' pos_features <- covars_make_pos(txt)
#' print(pos_features)
#' }
covars_make_pos <- function(x, 
                           pos_tags = c("ADJ", "ADV", "NOUN", "VERB", "ADP", "DET"),
                           normalize = TRUE,
                           model_language = "english-ewt") {
    
    # Convert to character if needed
    if (inherits(x, "corpus")) {
        x <- as.character(x)
    }
    
    # Check if model is downloaded, if not download it
    model_file <- system.file("models", 
                              paste0(model_language, ".udpipe"), 
                              package = "udpipe")
    
    if (!file.exists(model_file) || model_file == "") {
        message("Downloading ", model_language, " language model (one-time, ~17MB)...")
        model_download <- udpipe::udpipe_download_model(language = model_language)
        model_file <- model_download$file_model
        message("Model downloaded to: ", model_file)
    }
    
    # Load the model
    udmodel <- udpipe::udpipe_load_model(file = model_file)
    
    # Annotate the texts
    message("Annotating ", length(x), " texts...")
    annotated <- udpipe::udpipe_annotate(udmodel, x = x)
    annotated_df <- as.data.frame(annotated, detailed = TRUE)
    
    # Count POS tags for each document
    doc_ids <- unique(annotated_df$doc_id)
    result <- data.frame(doc_id = doc_ids, stringsAsFactors = FALSE)
    
    for (tag in pos_tags) {
        counts <- tapply(annotated_df$upos == tag, 
                        annotated_df$doc_id, 
                        sum, 
                        na.rm = TRUE)
        result[[paste0("pos_", tag)]] <- as.numeric(counts[result$doc_id])
    }
    
    # Normalize to proportions if requested
    if (normalize) {
        doc_lengths <- tapply(rep(1, nrow(annotated_df)), 
                             annotated_df$doc_id, 
                             sum)
        for (tag in pos_tags) {
            col_name <- paste0("pos_", tag)
            result[[col_name]] <- result[[col_name]] / as.numeric(doc_lengths[result$doc_id])
        }
    }
    
    return(result)
}
