# sophistication2: Package Update Summary

## What Was Fixed

The original `sophistication` package was last updated in May 2021 and built against quanteda v2.x. Since then:

1. **quanteda v3.0** (November 2021) introduced breaking changes
2. **quanteda v4.0** (May 2024) introduced more breaking changes
3. Readability functions moved to separate `quanteda.textstats` package
4. Several API functions renamed or restructured

This made the original package non-functional with modern R installations.

## Key Changes in sophistication2

### 1. Updated Dependencies

**Before:**
```r
Depends: quanteda (>= 2.1.9000)
Imports: spacyr, data.table, ...
```

**After:**
```r
Depends: R (>= 4.0.0)
Imports:
    quanteda (>= 4.0.0),
    quanteda.textstats (>= 0.96),
    data.table, ...
Suggests:
    spacyr (>= 1.2),  # Now optional!
```

### 2. Made spacyr Optional

**Problem:** spacyr requires Python + conda/miniconda, which is a heavy dependency.

**Solution:** Only `covars_make_pos()` needs spacyr. All other functions work without it.

**Before:** Package wouldn't install without working spacyr
**After:** Package installs cleanly, gives clear error if you try to use POS features without spacyr

### 3. Updated All quanteda API Calls

**Key changes:**
- `corpus_segment()` → `corpus_reshape()`
- `textstat_readability()` now in `quanteda.textstats` package
- `tokens()` and other functions have updated signatures
- `docnames()`, `docid()`, `texts()` work differently

### 4. Improved Documentation

- Clear installation instructions
- Migration guide from original package
- Examples that actually work
- Better error messages

### 5. Modern R Practices

- Minimum R version 4.0.0
- Roxygen2 7.3.1
- Proper NAMESPACE management
- Test suite included

## What Stayed the Same

- **All function names** (except internal changes)
- **Function signatures** (same arguments, same return values)
- **Methodology** (implements same Benoit, Munger, Spirling (2019) approach)
- **Core algorithms** (snippet generation, pair creation, readability bootstrap)

## Installation

### Quick Start (No spacyr)

```bash
# In R:
install.packages(c("quanteda", "quanteda.textstats", "data.table", "stringi", "MASS"))
devtools::install_github("yourname/sophistication2")
```

### Full Install (With spacyr)

```bash
# First install R dependencies
install.packages(c("quanteda", "quanteda.textstats", "spacyr"))

# Then install spaCy (Python)
library(spacyr)
spacy_install()

# Finally install sophistication2
devtools::install_github("yourname/sophistication2")
```

## Testing Your Installation

```r
library(sophistication2)
library(quanteda)

# This should work immediately
corp <- corpus(c("Simple text.", "Complex text with more words."))
snippets <- snippets_make(corp, nsentence = 1, minchar = 5, maxchar = 50)
print(snippets)

# If this works, you're good to go!
```

## Migrating Existing Code

Most code will work with these simple changes:

```r
# Add this line at the top
library(quanteda.textstats)

# Change nothing else - your existing sophistication code should work!
```

## Package Structure

```
sophistication2/
├── DESCRIPTION           # Package metadata (updated)
├── NAMESPACE            # Exports (updated for quanteda.textstats)
├── README.md            # User-facing documentation
├── NEWS.md              # Version history
├── INSTALL.md           # Detailed installation guide
├── R/
│   ├── sophistication2-package.R    # Package documentation
│   ├── snippets_make.R              # Snippet creation (updated)
│   ├── snippets_clean.R             # Snippet cleaning
│   ├── pairs_make.R                 # Pair generation
│   ├── pairs_gold_make.R            # Gold pair creation (updated)
│   ├── bootstrap_readability.R      # Bootstrap (MAJOR UPDATE)
│   ├── covars_make.R                # Covariate computation
│   ├── covars_make_pos.R            # POS features (now optional)
│   ├── predict_readability.R        # Prediction
│   └── cf_input_make.R              # Crowdsourcing formatting
├── tests/
│   ├── testthat.R
│   └── testthat/
│       └── test-basic.R             # Test suite
└── examples/
    └── complete_workflow.R          # Full example
```

## What Functions Work Without spacyr

✅ **Work without any Python/spacyr:**
- `snippets_make()` - Create text snippets
- `snippets_clean()` - Clean snippets
- `pairs_regular_make()` - Generate pairs
- `pairs_gold_make()` - Create gold pairs
- `bootstrap_readability()` - Bootstrap readability
- `covars_make()` - Basic text covariates (lexical diversity, etc.)
- `covars_make_baselines()` - Baseline statistics
- `predict_readability()` - Prediction
- `cf_input_make()` - Crowdsourcing formatting

❌ **Require spacyr:**
- `covars_make_pos()` - Part-of-speech features only

## Known Limitations

1. **Data not included**: The original package had example corpora. These are not included but available via `quanteda.corpora` package.

2. **Bradley-Terry functions**: The original had some Bradley-Terry paired comparison model code. This has been simplified in v0.80.0. Users should use dedicated Bradley-Terry packages.

3. **LIWC integration**: Original package had some LIWC integration. This has been removed. Users should use `quanteda.dictionaries` or custom dictionary approaches.

## Future Work

Potential improvements for future versions:

- [ ] Add back example data corpora
- [ ] Integrate modern Bradley-Terry implementations
- [ ] Add support for transformer-based sophistication measures
- [ ] Provide pre-trained sophistication models
- [ ] Add visualization functions for snippet pairs
- [ ] Support for non-English texts (currently English-focused)

## Getting Help

1. **Documentation**: See function help pages: `?snippets_make`
2. **Examples**: Run `examples/complete_workflow.R`
3. **Issues**: Report bugs at [your GitHub repo]
4. **Original paper**: Benoit, Munger, Spirling (2019) AJPS

## Citation

If you use this package, please cite the original paper:

```bibtex
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

## License

GPL-3 (same as original package)

## Credits

- **Original package**: Kenneth Benoit, Kevin Munger, Arthur Spirling
- **2026 update**: Updated for modern quanteda compatibility
- **Methodology**: Based on Benoit, Munger, Spirling (2019)

## Contact

- Original authors: See original package at https://github.com/kbenoit/sophistication
- This fork: [your contact info or GitHub]
