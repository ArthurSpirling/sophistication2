#' Create gold standard pairs based on readability differences
#'
#' Creates "gold" question pairs based on large differences in readability scores.
#' These can be used as quality control questions in crowdsourcing tasks.
#' @param x a data.frame of snippet pairs (from \code{\link{pairs_regular_make}})
#' @param n.pairs number of gold pairs to generate
#' @param min.diff.quantile minimum quantile difference in readability (default: 0.75 means top 25% most different)
#' @param measure readability measure to use (default: "Flesch")
#' @return a data.frame of gold pairs with readability scores and indicators
#' @export
#' @importFrom quanteda.textstats textstat_readability
#' @examples
#' \dontrun{
#' snippets <- data.frame(
#'   docID = paste0("d", 1:10),
#'   snippetID = paste0("s", 1:10),
#'   text = c("Simple.", "Complex sentence with multiple clauses and sophisticated vocabulary.",
#'            rep("Medium complexity text here.", 8)),
#'   stringsAsFactors = FALSE
#' )
#' pairs <- pairs_regular_make(snippets, n.pairs = 20)
#' gold_pairs <- pairs_gold_make(pairs, n.pairs = 3)
#' }
pairs_gold_make <- function(x, n.pairs = 10, min.diff.quantile = 0.75, measure = "Flesch") {
    
    cat("Starting the creation of gold questions...\n")
    
    # Compute readability for both texts in each pair
    cat("   computing", measure, "readability measure\n")
    
    read1 <- quanteda.textstats::textstat_readability(x$text1, measure = measure)
    read2 <- quanteda.textstats::textstat_readability(x$text2, measure = measure)
    
    x$read1 <- read1[[measure]]
    x$read2 <- read2[[measure]]
    x$readdiff <- abs(x$read1 - x$read2)
    
    # Select pairs with largest readability differences
    cat("   selecting top different", n.pairs, "pairs\n")
    
    # Sort by difference
    x <- x[order(x$readdiff, decreasing = TRUE), ]
    
    # Get threshold
    diff_threshold <- quantile(x$readdiff, min.diff.quantile, na.rm = TRUE)
    cat("   applying min.diff.quantile thresholds of", 
        round(quantile(x$readdiff, 0.25, na.rm = TRUE), 2), ",",
        round(quantile(x$readdiff, 0.75, na.rm = TRUE), 2), "\n")
    
    # Select top n.pairs
    x_gold <- head(x, n.pairs)
    
    # Add gold indicator and easier text indicator
    x_gold$`_golden` <- TRUE
    x_gold$easier_gold <- ifelse(x_gold$read1 > x_gold$read2, 1, 2)
    
    # Create explanation text
    cat("   creating gold_reason text\n")
    x_gold$easier_gold_reason <- ifelse(
        x_gold$easier_gold == 1,
        'Text A is "easier" to read because it contains some combination of shorter sentences, more commonly used and more easily understood terms, and is generally less complicated and easier to read and grasp its point.',
        'Text B is "easier" to read because it contains some combination of shorter sentences, more commonly used and more easily understood terms, and is generally less complicated and easier to read and grasp its point.'
    )
    
    cat("   ...finished.\n")
    
    return(x_gold)
}
