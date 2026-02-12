#' sophistication2: Measuring Text Sophistication
#'
#' Provides functions for measuring the sophistication of political texts based on
#' readability and linguistic features. Includes tools for creating text snippets,
#' generating comparison pairs, computing readability scores with bootstrap estimates,
#' and predicting text sophistication.
#'
#' @section Main Functions:
#' \itemize{
#'   \item \code{\link{snippets_make}} - Create text snippets from corpus
#'   \item \code{\link{snippets_clean}} - Clean problematic snippets
#'   \item \code{\link{pairs_regular_make}} - Generate snippet pairs
#'   \item \code{\link{pairs_gold_make}} - Create gold standard pairs
#'   \item \code{\link{bootstrap_readability}} - Bootstrap readability statistics
#'   \item \code{\link{covars_make}} - Compute text covariates
#'   \item \code{\link{covars_make_pos}} - Compute POS features (using udpipe)
#'   \item \code{\link{predict_readability}} - Predict readability scores
#' }
#'
#' @section Language Models:
#' The \code{\link{covars_make_pos}} function uses udpipe for part-of-speech tagging.
#' On first use, it automatically downloads the English language model (~17MB).
#' This is a pure R solution - no Python or external dependencies required.
#'
#' @docType package
#' @name sophistication2-package
#' @aliases sophistication2
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
