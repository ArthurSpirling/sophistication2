# Complete Workflow Example for sophistication2

# This script demonstrates a complete text sophistication analysis workflow
# using the sophistication2 package with modern quanteda.

# =============================================================================
# SETUP
# =============================================================================

library(sophistication2)
library(quanteda)
library(quanteda.textstats)

# Optional: if you need POS features
# library(spacyr)
# spacy_initialize()

# =============================================================================
# STEP 1: LOAD AND PREPARE DATA
# =============================================================================

# Example: Using State of the Union addresses
# You can install quanteda.corpora for this data:
# install.packages("quanteda.corpora", 
#                  repos = "http://quanteda.org/r-drat")

data(data_corpus_sotu, package = "quanteda.corpora")

# Subset to recent presidents for faster processing
corp_recent <- corpus_subset(data_corpus_sotu, 
                             Year >= 2000)

print(paste("Working with", ndoc(corp_recent), "documents"))

# =============================================================================
# STEP 2: CREATE TEXT SNIPPETS
# =============================================================================

# Create snippets: 1 sentence each, 150-250 characters
# This creates manageable chunks for human comparison
snippets <- snippets_make(
    corp_recent,
    nsentence = 1,      # 1 sentence per snippet
    minchar = 150,      # minimum 150 characters
    maxchar = 250       # maximum 250 characters
)

print(paste("Created", nrow(snippets), "snippets"))
head(snippets, 3)

# =============================================================================
# STEP 3: CLEAN SNIPPETS
# =============================================================================

# Remove problematic snippets (ALL CAPS, large numbers, etc.)
snippets_clean <- snippets_clean(
    snippets,
    remove_allcaps = TRUE,
    remove_bignumbers = TRUE,
    min_words = 10
)

print(paste("After cleaning:", nrow(snippets_clean), "snippets"))

# =============================================================================
# STEP 4: GENERATE COMPARISON PAIRS
# =============================================================================

# Create pairs for human comparison
# These would be shown to crowdworkers or experts
set.seed(42)
pairs <- pairs_regular_make(snippets_clean, n.pairs = 100)

print(paste("Created", nrow(pairs), "pairs"))
print("Example pair:")
print(pairs[1, c("text1", "text2")])

# =============================================================================
# STEP 5: CREATE GOLD STANDARD PAIRS
# =============================================================================

# Generate gold standard pairs with known readability differences
# These are used for quality control in crowdsourcing
gold_pairs <- pairs_gold_make(
    pairs, 
    n.pairs = 10,
    measure = "Flesch"
)

print(paste("Created", nrow(gold_pairs), "gold pairs"))
print("Gold pair readability differences:")
print(gold_pairs[, c("read1", "read2", "readdiff", "easier_gold")])

# =============================================================================
# STEP 6: PREPARE FOR CROWDSOURCING (OPTIONAL)
# =============================================================================

# Format all pairs for upload to crowdsourcing platform
cf_data <- cf_input_make(pairs, gold_pairs = gold_pairs)

print(paste("Crowdsourcing data has", nrow(cf_data), "total rows"))
print(paste("Including", sum(cf_data$`_golden`), "gold pairs"))

# Export for upload
# write.csv(cf_data, "crowdflower_input.csv", row.names = FALSE)

# =============================================================================
# STEP 7: COMPUTE READABILITY STATISTICS
# =============================================================================

# Compute standard readability measures
readability_scores <- textstat_readability(
    corpus(snippets_clean$text),
    measure = c("Flesch", "Flesch.Kincaid", "Coleman.Liau")
)

print("Readability summary:")
print(summary(readability_scores))

# =============================================================================
# STEP 8: BOOTSTRAP READABILITY FOR UNCERTAINTY
# =============================================================================

# Compute bootstrapped readability with standard errors
# This is useful for reporting uncertainty in sophistication measures
sample_texts <- sample(snippets_clean$text, 20)

boot_result <- bootstrap_readability(
    sample_texts,
    measure = "Flesch",
    n = 100,
    verbose = TRUE
)

print("Bootstrap results:")
print(paste("Mean:", round(boot_result$mean, 2)))
print(paste("SE:", round(boot_result$se, 2)))
print(paste("95% CI:", 
            round(boot_result$mean - 1.96 * boot_result$se, 2), "to",
            round(boot_result$mean + 1.96 * boot_result$se, 2)))

# =============================================================================
# STEP 9: EXTRACT TEXT FEATURES (COVARIATES)
# =============================================================================

# Compute linguistic covariates for sophistication modeling
covars <- covars_make(sample_texts)

print("Text covariates:")
print(head(covars))
print("Covariate summary:")
print(summary(covars))

# Optional: Compute baseline statistics for normalization
baseline <- covars_make_baselines(snippets_clean$text)
print("Baseline statistics:")
print(baseline[1:2])  # Show first two covariates

# =============================================================================
# STEP 10: BUILD SOPHISTICATION MODEL (EXAMPLE)
# =============================================================================

# Combine readability and covariates
model_data <- cbind(
    readability = readability_scores$Flesch[1:length(sample_texts)],
    covars
)

# Fit a simple regression model
# In practice, you would use Bradley-Terry or other paired comparison models
soph_model <- lm(readability ~ n_tokens + ttr + avg_word_length, 
                 data = model_data)

print("Sophistication model summary:")
print(summary(soph_model))

# =============================================================================
# STEP 11: PREDICT SOPHISTICATION FOR NEW TEXTS
# =============================================================================

# Predict readability for new texts
new_texts <- c(
    "This is a simple sentence.",
    "Sophisticated prose requires careful attention to lexical choice."
)

new_covars <- covars_make(new_texts)
predictions <- predict_readability(soph_model, new_covars, 
                                   measure = "predicted_sophistication")

print("Predictions for new texts:")
print(data.frame(
    text = new_texts,
    predicted = predictions,
    stringsAsFactors = FALSE
))

# =============================================================================
# ADVANCED: POS FEATURES (REQUIRES SPACYR)
# =============================================================================

# Only run if spacyr is installed and initialized
if (requireNamespace("spacyr", quietly = TRUE) && 
    spacyr::spacy_is_installed()) {
    
    print("Computing POS features...")
    
    # Make sure spaCy is initialized
    if (!spacyr::spacy_initialized()) {
        spacyr::spacy_initialize()
    }
    
    pos_covars <- covars_make_pos(
        sample(snippets_clean$text, 10),
        pos_tags = c("NOUN", "VERB", "ADJ", "ADV")
    )
    
    print("POS covariate summary:")
    print(summary(pos_covars[, -1]))  # Exclude doc_id column
    
    # Clean up
    # spacyr::spacy_finalize()
} else {
    print("Skipping POS features (spacyr not available)")
    print("Install with: install.packages('spacyr'); library(spacyr); spacy_install()")
}

# =============================================================================
# SUMMARY
# =============================================================================

cat("\n=== WORKFLOW COMPLETE ===\n")
cat("Results summary:\n")
cat("- Processed", ndoc(corp_recent), "documents\n")
cat("- Created", nrow(snippets_clean), "clean snippets\n")
cat("- Generated", nrow(pairs), "comparison pairs\n")
cat("- Included", nrow(gold_pairs), "gold standard pairs\n")
cat("- Computed readability and covariates\n")
cat("- Built example sophistication model\n")
cat("\nNext steps:\n")
cat("1. Upload pairs to crowdsourcing platform\n")
cat("2. Collect human judgments\n")
cat("3. Fit Bradley-Terry model on judgments\n")
cat("4. Validate against readability measures\n")
