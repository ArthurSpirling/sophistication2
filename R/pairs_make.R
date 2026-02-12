#' Create pairs of text snippets for comparison
#'
#' Creates pairs of text snippets for human comparison tasks.
#' @param x a data.frame of snippets (from \code{\link{snippets_make}})
#' @param n.pairs number of pairs to generate (if NULL, uses all possible pairs up to a maximum)
#' @return a data.frame with snippet pairs for comparison
#' @export
#' @examples
#' \dontrun{
#' snippets <- data.frame(
#'   docID = paste0("d", 1:5),
#'   snippetID = paste0("s", 1:5),
#'   text = c("Simple sentence.", "More complex text here with clauses.", 
#'            "Another example.", "Very sophisticated prose indeed.",
#'            "Basic statement."),
#'   stringsAsFactors = FALSE
#' )
#' pairs_regular_make(snippets, n.pairs = 3)
#' }
pairs_regular_make <- function(x, n.pairs = NULL) {
    
    n_snippets <- nrow(x)
    
    if (n_snippets < 2) {
        stop("Need at least 2 snippets to create pairs")
    }
    
    # Maximum possible pairs
    max_pairs <- choose(n_snippets, 2)
    
    # Determine number of pairs to generate
    if (is.null(n.pairs)) {
        n.pairs <- min(max_pairs, 1000)  # Default: up to 1000 pairs
    } else {
        n.pairs <- min(n.pairs, max_pairs)
    }
    
    # Sample pairs
    pair_indices <- combn(n_snippets, 2)
    
    if (ncol(pair_indices) > n.pairs) {
        # Random sample of pairs
        sample_cols <- sample(ncol(pair_indices), n.pairs)
        pair_indices <- pair_indices[, sample_cols, drop = FALSE]
    }
    
    # Build result data.frame
    result <- data.frame(
        docID1 = x$docID[pair_indices[1, ]],
        snippetID1 = x$snippetID[pair_indices[1, ]],
        text1 = x$text[pair_indices[1, ]],
        docID2 = x$docID[pair_indices[2, ]],
        snippetID2 = x$snippetID[pair_indices[2, ]],
        text2 = x$text[pair_indices[2, ]],
        stringsAsFactors = FALSE
    )
    
    return(result)
}
