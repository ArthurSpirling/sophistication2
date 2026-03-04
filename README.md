# sophistication2: Measuring Text Sophistication (vibe coding to remove Python dependency)

[![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)]()

## Overview

**sophistication2** is an updated version of the `sophistication` package, providing functions for measuring the sophistication of political texts based on readability and linguistic features. This is very much a trial/beta release. I (**Arthur Spirling**) vibecoded it from in ~20 minutes using Claude Sonnet 4.5, mostly as  proof of concept of coding ability. I haven't checked it in any great detail, though the main functions appear to work ok.    If you find errors, let me know! 

This package should implement the methodology from:

> Benoit, Kenneth, Kevin Munger, and Arthur Spirling. 2019. "Measuring and Explaining Political Sophistication Through Textual Complexity." *American Journal of Political Science* 63(2): 491-508. <https://doi.org/10.1111/ajps.12423>


### What's New in sophistication2 v0.81

This updated version addresses compatibility issues with modern R packages:

- ✅ **Updated for quanteda v4.x** - Works with current quanteda ecosystem
- ✅ **Uses quanteda.textstats** - Proper handling of readability functions  
- ✅ **Pure R - No Python!** - Uses udpipe for POS tagging (no spacyr/spaCy required)
- ✅ **Automatic model download** - First use downloads English model (~17MB)
- ✅ **Improved error messages** - Clear guidance when issues occur
- ✅ **Modern R practices** - Compatible with R >= 4.0.0
- ✅ **Perfect for teaching** - No conda/Python headaches for students

## Installation

### Simple Installation (Everything in R)

```r
# Install dependencies
install.packages(c("quanteda", "quanteda.textstats", "data.table", 
                   "stringi", "MASS", "udpipe"))

# Install sophistication2
devtools::install_github("yourname/sophistication2")
```

**That's it!** No Python, no conda, no spaCy - everything works in pure R.

## Quick Start

```r
library(sophistication2)
library(quanteda)
library(quanteda.textstats)

# Create simple test data
txt <- c("This is a simple sentence.", 
         "This sentence contains more complex linguistic structures.")

# Test snippet creation
corp <- corpus(txt)
snippets <- snippets_make(corp, nsentence = 1, minchar = 10, maxchar = 100)
print(snippets)

# Test readability
read_scores <- textstat_readability(corp, measure = "Flesch")
print(read_scores)

# Compute POS features (downloads model on first use - takes ~30 seconds)
pos_features <- covars_make_pos(txt)
print(pos_features)
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

### Feature Extraction (All in Pure R!)
- `covars_make()` - Compute basic text covariates (lexical diversity, sentence length, etc.)
- `covars_make_baselines()` - Compute baseline statistics for normalization
- `covars_make_pos()` - Compute POS features using udpipe (pure R!)

### Crowdsourcing Support
- `cf_input_make()` - Format pairs for CrowdFlower/Figure Eight upload

## Complete Example Workflow

```r
library(sophistication2)
library(quanteda)
library(quanteda.textstats)
library(quanteda.corpora)

# 1. Load data
data(data_corpus_sotu, package = "quanteda.corpora")
corp <- corpus_subset(data_corpus_sotu, Year >= 2000)

# 2. Create and clean snippets  
snippets <- snippets_make(corp, nsentence = 1, minchar = 150, maxchar = 250)
snippets_clean <- snippets_clean(snippets)

# 3. Generate comparison pairs
pairs <- pairs_regular_make(snippets_clean, n.pairs = 100)

# 4. Add gold pairs for quality control
gold <- pairs_gold_make(pairs, n.pairs = 10)

# 5. Format for crowdsourcing
cf_data <- cf_input_make(pairs, gold_pairs = gold)

# 6. Compute readability with bootstrap
boot <- bootstrap_readability(snippets_clean$text[1:20], 
                              measure = "Flesch", n = 100)

# 7. Extract text features (pure R, no Python!)
covars <- covars_make(snippets_clean$text[1:20])
pos_features <- covars_make_pos(snippets_clean$text[1:10])
```

## Why udpipe Instead of spacyr?

**spacyr** (the old approach):
- ❌ Requires Python installation
- ❌ Requires conda/miniconda
- ❌ Complex setup, especially on Windows
- ❌ Version conflicts between R and Python
- ❌ Nightmare for classroom use

**udpipe** (the new approach):
- ✅ Pure R - no Python needed
- ✅ Automatic model download
- ✅ Fast and accurate (Universal Dependencies)
- ✅ Easy for students to install
- ✅ Works identically on all platforms

Performance is comparable for most NLP tasks, and the ease of use far outweighs any minor accuracy differences.

## Key Differences from Original Package

| Feature | Original sophistication | sophistication2 v0.81 |
|---------|------------------------|-----------------|
| quanteda | v2.x (2019-2021) | v4.x (2024+) |
| Readability | `quanteda::textstat_readability()` | `quanteda.textstats::textstat_readability()` |
| POS tagging | spacyr (Python required) | udpipe (pure R) |
| R version | >= 3.2 | >= 4.0 |
| Installation | Complex (Python+R) | Simple (R only) |
| Classroom ready | No | Maybe (not stress tested) |

## Dependencies

### Required (all pure R)
- quanteda >= 4.0.0
- quanteda.textstats >= 0.96  
- udpipe >= 0.8
- data.table
- stringi
- MASS

### Optional
- quanteda.corpora (for examples)
- testthat (for testing)

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
library(spacyr)
spacy_initialize()
pos_features <- covars_make_pos(texts)  # Uses spacyr

# New code  
library(sophistication2)
pos_features <- covars_make_pos(texts)  # Uses udpipe - no Python!
```

Most function signatures remain the same, so your existing code should work with minimal changes.

## Perfect for Teaching!

This package is ideal for text analysis courses because:

1. **No Python setup headaches** - Students just install R packages
2. **Works on all platforms** - Windows, Mac, Linux identical
3. **Automatic downloads** - Language models download on first use
4. **Clear error messages** - Students know what to do when things break
5. **Fast installation** - `install.packages()` and done

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
- 📚 [udpipe documentation](https://bnosac.github.io/udpipe/en/)

## License

GPL-3 (same as original package)

## Acknowledgments

This package is a maintenance update of Kenneth Benoit, Kevin Munger, and Arthur Spirling's original `sophistication` package. All credit for the methodology and original implementation goes to the original authors. This update ensures compatibility with modern R infrastructure and removes Python dependencies for easier classroom use.
