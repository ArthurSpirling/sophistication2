# sophistication2: Measuring Text Sophistication (Updated for Modern quanteda)

[![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)]()

## Overview

**sophistication2** is an updated version of the `sophistication` package, providing functions for measuring the sophistication of political texts based on readability and linguistic features. This package implements the methodology from:

> Benoit, Kenneth, Kevin Munger, and Arthur Spirling. 2019. "Measuring and Explaining Political Sophistication Through Textual Complexity." *American Journal of Political Science* 63(2): 491-508. <https://doi.org/10.1111/ajps.12423>

### What's New in sophistication2

This updated version addresses compatibility issues with modern R packages:

- ✅ **Updated for quanteda v4.x** - Works with current quanteda ecosystem
- ✅ **Uses quanteda.textstats** - Proper handling of readability functions  
- ✅ **spacyr is now truly optional** - Core functionality works without Python dependencies
- ✅ **Improved error messages** - Clear guidance when optional dependencies are missing
- ✅ **Modern R practices** - Compatible with R >= 4.0.0

## Installation

### Basic Installation (without spacyr)

For core sophistication measurement (readability, snippets, pairs):

```r
# Install from GitHub
devtools::install_github("yourname/sophistication2")
```

This will work immediately for most functions. You only need spacyr for POS (part-of-speech) analysis.

### Full Installation (with spacyr)

If you need POS tagging features:

```r
# Install sophistication2
devtools::install_github("yourname/sophistication2")

# Install spacyr and spaCy
install.packages("spacyr")
library(spacyr)
spacy_install()

# Initialize spaCy for POS analysis
spacy_initialize()
```

## Quick Start

```r
library(sophistication2)
library(quanteda)
library(quanteda.corpora)

# Load example data
data(data_corpus_sotu, package = "quanteda.corpora")

# Create snippets: 1 sentence each, 150-250 characters
snippets <- snippets_make(data_corpus_sotu, 
                          nsentence = 1, 
                          minchar = 150, 
                          maxchar = 250)
                          
# Clean problematic snippets
snippets_clean <- snippets_clean(snippets)

# Create pairs for comparison
pairs <- pairs_regular_make(snippets_clean, n.pairs = 100)

# Create gold standard pairs (for quality control)
gold_pairs <- pairs_gold_make(pairs, n.pairs = 10)

# Bootstrap readability statistics
bootstrap_result <- bootstrap_readability(
    c("This is a simple sentence.", 
      "This sentence contains more complex linguistic structures."),
    measure = "Flesch",
    n = 100
)
```

## Main Functions

### Snippet Creation
- `snippets_make()` - Extract text snippets from corpus
- `snippets_clean()` - Remove problematic snippets (ALL CAPS, big numbers, etc.)

### Pair Generation  
- `pairs_regular_make()` - Create snippet pairs for comparison
- `pairs_gold_make()` - Create gold standard pairs based on readability differences

### Readability Analysis
- `bootstrap_readability()` - Compute bootstrapped readability with standard errors
- `predict_readability()` - Predict readability for new texts

### Feature Extraction
- `covars_make()` - Compute basic text covariates (lexical diversity, sentence length, etc.)
- `covars_make_baselines()` - Compute baseline statistics for normalization
- `covars_make_pos()` - Compute POS features (requires spacyr)

### Crowdsourcing Support
- `cf_input_make()` - Format pairs for CrowdFlower/Figure Eight upload

## Example Workflow

```r
library(sophistication2)

# 1. Prepare text data
corp <- corpus(c(
    "The quick brown fox jumps over the lazy dog.",
    "Sophisticated textual analysis requires careful methodological consideration of various linguistic features.",
    "Simple words make reading easy."
))

# 2. Create and clean snippets  
snip <- snippets_make(corp, nsentence = 1, minchar = 20, maxchar = 200)
snip <- snippets_clean(snip)

# 3. Generate comparison pairs
pairs <- pairs_regular_make(snip, n.pairs = 10)

# 4. Add gold pairs for quality control
gold <- pairs_gold_make(pairs, n.pairs = 2)

# 5. Format for crowdsourcing
cf_data <- cf_input_make(pairs, gold_pairs = gold)

# 6. Compute readability
library(quanteda.textstats)
readability <- textstat_readability(corp, measure = "Flesch")
```

## Key Differences from Original Package

| Feature | Original sophistication | sophistication2 |
|---------|------------------------|-----------------|
| quanteda | v2.x (2019-2021) | v4.x (2024+) |
| Readability | `quanteda::textstat_readability()` | `quanteda.textstats::textstat_readability()` |
| spacyr | Required (hard dependency) | Optional (only for POS) |
| R version | >= 3.2 | >= 4.0 |
| Error messages | Generic | Specific with installation help |

## Dependencies

### Required
- quanteda >= 4.0.0
- quanteda.textstats >= 0.96  
- data.table
- stringi
- MASS

### Optional
- spacyr >= 1.2 (only for `covars_make_pos()`)
- quanteda.corpora (for examples)

## Included Data

The package includes several example corpora:

- `data_corpus_fifthgrade` - Fifth-grade reading texts
- `data_corpus_crimson` - Harvard *Crimson* editorials  
- `data_corpus_partybroadcast` - UK political party broadcasts
- `data_corpus_presdebates` - US presidential debates 2016

## Migration from Original Package

If you're upgrading from the original `sophistication` package:

```r
# Old code
library(sophistication)
read_stats <- textstat_readability(corp)  # Fails with quanteda 4.x

# New code  
library(sophistication2)
library(quanteda.textstats)
read_stats <- textstat_readability(corp)  # Works!
```

Most function signatures remain the same, so your existing code should work with minimal changes.

## Citation

If you use this package, please cite the original paper:

```
@article{benoit2019measuring,
  title={Measuring and Explaining Political Sophistication Through Textual Complexity},
  author={Benoit, Kenneth and Munger, Kevin and Spirling, Arthur},
  journal={American Journal of Political Science},
  volume={63},
  number={2},
  pages={491--508},
  year={2019},
  doi={10.1111/ajps.12423}
}
```

## Getting Help

- 📖 [Original package documentation](https://github.com/kbenoit/sophistication)
- 🐛 [Report issues](https://github.com/yourname/sophistication2/issues)
- 💬 [quanteda tutorials](https://tutorials.quanteda.io/)

## License

GPL-3 (same as original package)

## Acknowledgments

This package is a maintenance update of Kenneth Benoit, Kevin Munger, and Arthur Spirling's original `sophistication` package. All credit for the methodology and original implementation goes to the original authors. This update simply ensures compatibility with modern R package infrastructure.
