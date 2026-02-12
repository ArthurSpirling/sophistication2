# Installation and Migration Guide

## For New Users

### Quick Install

```r
# Install dependencies
install.packages(c("quanteda", "quanteda.textstats", "data.table", "stringi", "MASS"))

# Install sophistication2 from GitHub
devtools::install_github("yourname/sophistication2")
```

### Testing Your Installation

```r
library(sophistication2)

# Test basic functionality
test_text <- c(
    "This is a simple sentence.",
    "This sentence demonstrates more complex syntactic structures."
)

# Should work without any additional setup
snippets <- data.frame(
    docID = c("d1", "d2"),
    snippetID = c("s1", "s2"),
    text = test_text,
    stringsAsFactors = FALSE
)

pairs <- pairs_regular_make(snippets)
print(pairs)
```

If this works, you're all set for basic sophistication analysis!

### Optional: Installing spacyr (for POS features)

Only needed if you want to use `covars_make_pos()`:

```r
install.packages("spacyr")
library(spacyr)

# This downloads and installs spaCy (Python library)
spacy_install()

# Initialize for use
spacy_initialize()

# Test it
covars_make_pos(c("The quick brown fox jumps."))

# When done
spacy_finalize()
```

## For Users of the Original Package

### What Changed?

The original `sophistication` package (last updated 2021) was built for quanteda v2.x. Modern quanteda (v4.x, released 2024) introduced breaking API changes. Key differences:

1. **Package name**: `sophistication` → `sophistication2`
2. **quanteda version**: v2.x → v4.x
3. **Readability functions**: Moved to separate `quanteda.textstats` package
4. **spacyr dependency**: Required → Optional

### Migration Steps

#### Step 1: Remove old package

```r
remove.packages("sophistication")
```

#### Step 2: Update quanteda

```r
install.packages("quanteda")
install.packages("quanteda.textstats")
```

#### Step 3: Install sophistication2

```r
devtools::install_github("yourname/sophistication2")
```

#### Step 4: Update your code

Most code will work with minimal changes:

**Old code:**
```r
library(sophistication)
library(quanteda)

# This fails with quanteda v4
corp <- corpus(my_texts)
read_scores <- textstat_readability(corp)
```

**New code:**
```r
library(sophistication2)
library(quanteda)
library(quanteda.textstats)  # NEW: explicit import

corp <- corpus(my_texts)
read_scores <- textstat_readability(corp)  # Now works!
```

### Function-by-Function Migration

| Original Function | New Status | Changes Needed |
|------------------|------------|----------------|
| `snippets_make()` | ✅ Works | None |
| `snippets_clean()` | ✅ Works | None |
| `pairs_regular_make()` | ✅ Works | None (formerly `pairSnippets()`) |
| `pairs_gold_make()` | ✅ Works | None (formerly `makeGold()`) |
| `bootstrap_readability()` | ✅ Works | Add `library(quanteda.textstats)` |
| `covars_make()` | ✅ Works | None |
| `covars_make_pos()` | ⚠️ Optional | Now requires explicit spacyr install |
| `cf_input_make()` | ✅ Works | None (formerly `makeCFdata()`) |

### Common Issues and Solutions

#### Issue: "could not find function 'textstat_readability'"

**Solution:**
```r
library(quanteda.textstats)
```

#### Issue: "spacyr package required"

**Solution:** 
Either install spacyr (see above) or avoid `covars_make_pos()`. All other functions work fine without it.

#### Issue: "corpus_segment not found"

This function was removed in quanteda v4. Use `corpus_reshape()` instead:

**Old:**
```r
corp_sent <- corpus_segment(corp, what = "sentences")
```

**New:**
```r
corp_sent <- corpus_reshape(corp, to = "sentences")
```

## Troubleshooting

### Getting Help

1. Check if you have compatible versions:
```r
packageVersion("quanteda")        # Should be >= 4.0.0
packageVersion("quanteda.textstats")  # Should be >= 0.96
packageVersion("sophistication2")    # Should be 0.80.0
```

2. Try a minimal example:
```r
library(sophistication2)
library(quanteda)
snippets <- snippets_make(
    corpus(c("Text one here.", "Text two here.")),
    nsentence = 1
)
```

3. Check the GitHub issues: [link to your repo]

### System Requirements

- R >= 4.0.0
- quanteda >= 4.0.0
- For spacyr: Python 3.x with working conda/miniconda

## Reporting Issues

If you encounter problems:

1. Include output of `sessionInfo()`
2. Provide a minimal reproducible example
3. Specify whether you need spacyr functionality
4. Post to GitHub issues: [your repo link]
