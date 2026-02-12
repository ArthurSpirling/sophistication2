#' Clean text snippets
#'
#' Removes snippets containing numbers >= 1000, ALL CAPS titles, or other problematic patterns.
#' @param x a data.frame with text snippets (from \code{\link{snippets_make}})
#' @param remove_allcaps if \code{TRUE}, remove snippets with ALL CAPS titles
#' @param remove_bignumbers if \code{TRUE}, remove snippets containing numbers >= 1000
#' @param min_words minimum number of words required
#' @param verbose if \code{TRUE}, print progress messages
#' @return a cleaned data.frame of snippets
#' @export
#' @importFrom stringi stri_detect_regex stri_count_boundaries
#' @examples
#' \dontrun{
#' snippets <- data.frame(
#'   docID = c("d1", "d2", "d3"),
#'   snippetID = c("s1", "s2", "s3"),
#'   text = c("Normal text here.", "SHOUTING TEXT ALERT!", "The year 2024 was fine."),
#'   stringsAsFactors = FALSE
#' )
#' snippets_clean(snippets)
#' }
snippets_clean <- function(x, 
                          remove_allcaps = TRUE, 
                          remove_bignumbers = TRUE,
                          min_words = 5,
                          verbose = TRUE) {
    
    if (verbose) {
        cat("Cleaning", nrow(x), "snippets...\n")
    }
    
    initial_n <- nrow(x)
    
    # Remove snippets with big numbers (>= 1000)
    if (remove_bignumbers) {
        has_bignumber <- stringi::stri_detect_regex(x$text, "\\b[1-9][0-9]{3,}\\b")
        n_removed <- sum(has_bignumber, na.rm = TRUE)
        if (n_removed > 0) {
            x <- x[!has_bignumber, ]
            if (verbose) {
                cat("   removed", n_removed, "snippets containing numbers of at least 1,000\n")
            }
        }
    }
    
    # Remove ALL CAPS snippets (e.g., titles, headers)
    if (remove_allcaps) {
        # Consider a snippet ALL CAPS if most words are capitalized
        # Pattern: at least 3 words that are all caps
        has_allcaps <- stringi::stri_detect_regex(x$text, "\\b[A-Z]{3,}\\b.*\\b[A-Z]{3,}\\b.*\\b[A-Z]{3,}\\b")
        n_removed <- sum(has_allcaps, na.rm = TRUE)
        if (n_removed > 0) {
            x <- x[!has_allcaps, ]
            if (verbose) {
                cat("   removed", n_removed, "snippets containing ALL CAPS titles\n")
            }
        }
    }
    
    # Remove snippets with too few words
    if (!is.null(min_words) && min_words > 0) {
        word_counts <- stringi::stri_count_boundaries(x$text, type = "word")
        too_few_words <- word_counts < min_words
        n_removed <- sum(too_few_words, na.rm = TRUE)
        if (n_removed > 0) {
            x <- x[!too_few_words, ]
            if (verbose) {
                cat("   removed", n_removed, "snippets with fewer than", min_words, "words\n")
            }
        }
    }
    
    if (verbose) {
        cat("   ...finished.\n")
    }
    
    rownames(x) <- NULL
    return(x)
}
