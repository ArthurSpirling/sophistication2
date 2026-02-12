#' Create input for crowdsourcing platforms
#'
#' Formats snippet pairs for upload to crowdsourcing platforms like CrowdFlower/Figure Eight.
#' @param pairs a data.frame of snippet pairs
#' @param gold_pairs optional data.frame of gold standard pairs
#' @return a data.frame formatted for crowdsourcing upload
#' @export
#' @examples
#' \dontrun{
#' snippets <- data.frame(
#'   docID = paste0("d", 1:5),
#'   snippetID = paste0("s", 1:5),
#'   text = paste("Text", 1:5),
#'   stringsAsFactors = FALSE
#' )
#' pairs <- pairs_regular_make(snippets, n.pairs = 3)
#' cf_input_make(pairs)
#' }
cf_input_make <- function(pairs, gold_pairs = NULL) {
    
    # Combine regular and gold pairs if provided
    if (!is.null(gold_pairs)) {
        # Ensure gold pairs have the _golden column
        if (!"_golden" %in% names(gold_pairs)) {
            gold_pairs$`_golden` <- TRUE
        }
        
        # Ensure regular pairs don't have it
        pairs$`_golden` <- FALSE
        
        # Combine
        all_pairs <- rbind(pairs, gold_pairs)
    } else {
        all_pairs <- pairs
        all_pairs$`_golden` <- FALSE
    }
    
    # Add unique ID
    all_pairs$pair_id <- 1:nrow(all_pairs)
    
    # Reorder columns for CF format
    col_order <- c("pair_id", "_golden", names(all_pairs)[!names(all_pairs) %in% c("pair_id", "_golden")])
    all_pairs <- all_pairs[, col_order]
    
    return(all_pairs)
}
