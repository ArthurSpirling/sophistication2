# Test script for udpipe-based POS tagging in sophistication2
# No Python required!

library(sophistication2)
library(quanteda)

cat("=== sophistication2 udpipe POS Tagging Test ===\n\n")

# Test 1: Basic POS tagging
cat("Test 1: Basic POS tagging\n")
cat("--------------------------\n")

test_texts <- c(
  "The quick brown fox jumps over the lazy dog.",
  "Sophisticated political discourse requires careful analytical consideration of multiple perspectives."
)

cat("Computing POS features for 2 texts...\n")
cat("(First use will download ~17MB English model - this is normal)\n\n")

pos_result <- covars_make_pos(test_texts)
print(pos_result)

cat("\n\nTest 2: Larger corpus\n")
cat("----------------------\n")

# Load some real data
data(data_corpus_sotu, package = "quanteda.corpora")
corp_subset <- corpus_subset(data_corpus_sotu, Year >= 2020)

# Get first 20 sentences
corp_sent <- corpus_reshape(corp_subset, to = "sentences")
sample_texts <- as.character(corp_sent)[1:20]

cat("Processing 20 sentences from recent SOTU addresses...\n")

system.time({
  pos_result_large <- covars_make_pos(sample_texts)
})

cat("\nPOS feature summary:\n")
print(summary(pos_result_large[, -1]))

cat("\n\nTest 3: Integration with other features\n")
cat("----------------------------------------\n")

# Combine POS with other text features
basic_covars <- covars_make(sample_texts[1:5])
pos_covars <- covars_make_pos(sample_texts[1:5])

cat("Basic covariates:\n")
print(names(basic_covars))

cat("\nPOS covariates:\n")
print(names(pos_covars))

cat("\n=== All tests completed successfully! ===\n")
cat("\nKey points:\n")
cat("- No Python required\n")
cat("- Model downloads automatically on first use\n")
cat("- Model is cached for future use\n")
cat("- Pure R implementation via udpipe\n")
cat("- Uses Universal Dependencies tagset\n")
