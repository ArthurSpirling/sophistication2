#' Predict readability scores
#'
#' Predicts readability scores for new texts based on a trained model.
#' @param model a fitted model object (e.g., from \code{lm} or other regression)
#' @param newdata data.frame of covariates for prediction
#' @param measure readability measure name (for labeling)
#' @return a data.frame with predicted readability scores
#' @export
#' @importFrom stats predict
#' @examples
#' \dontrun{
#' # Train a simple model
#' train_data <- data.frame(
#'   readability = rnorm(100, mean = 50, sd = 10),
#'   n_tokens = rnorm(100, mean = 100, sd = 20),
#'   ttr = rnorm(100, mean = 0.5, sd = 0.1)
#' )
#' model <- lm(readability ~ n_tokens + ttr, data = train_data)
#' 
#' # Predict on new data
#' new_data <- data.frame(
#'   n_tokens = c(90, 110),
#'   ttr = c(0.45, 0.55)
#' )
#' predict_readability(model, new_data)
#' }
predict_readability <- function(model, newdata, measure = "predicted") {
    
    # Make predictions
    preds <- predict(model, newdata = newdata)
    
    # Return as data.frame
    result <- data.frame(
        prediction = preds,
        stringsAsFactors = FALSE
    )
    names(result) <- measure
    
    return(result)
}
