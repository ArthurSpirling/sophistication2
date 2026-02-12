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
#'   \item \code{\link{predict_readability}} - Predict readability scores
#' }
#'
#' @section Optional Dependencies:
#' The \code{spacyr} package is only required for the \code{\link{covars_make_pos}}
#' function which computes part-of-speech features. All other functions work without
#' spacyr.
#'
#' @docType package
#' @name sophistication2-package
#' @aliases sophistication2
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
