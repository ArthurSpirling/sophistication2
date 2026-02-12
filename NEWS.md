# sophistication2 0.81.0

## Major Changes - Python Removed!

* **BREAKING**: Removed all Python/spacyr dependencies
* **NEW**: POS tagging now uses udpipe (pure R implementation)
* **NEW**: Automatic language model download on first use (~17MB)
* Models cached locally - only downloads once
* Perfect for classroom use - no conda/Python setup required

## udpipe Integration

* `covars_make_pos()` now uses udpipe instead of spacyr
* Uses Universal Dependencies tagset (same as spacyr)
* First use automatically downloads English model
* Model stored in package directory for future use
* Performance comparable to spaCy for most tasks

## Why This Change?

The spacyr/spaCy dependency chain was problematic:
- Required Python installation
- Required conda/miniconda
- Complex setup, especially on Windows
- Version conflicts between R and Python
- Difficult for students in classroom settings

udpipe solves all these problems with pure R implementation.

## Migration from v0.80.0

If you used spacyr-based POS features:

```r
# Old (v0.80.0 with spacyr)
library(spacyr)
spacy_initialize()
pos <- covars_make_pos(texts)
spacy_finalize()

# New (v0.81.0 with udpipe)
pos <- covars_make_pos(texts)  # That's it!
```

Everything else remains the same.

---

# sophistication2 0.80.0

## Major Changes

* **BREAKING**: Package renamed to `sophistication2` to distinguish from original
* **BREAKING**: Now requires quanteda >= 4.0.0 (up from 2.x)
* **BREAKING**: Readability functions now use `quanteda.textstats::textstat_readability()`
* Made spacyr optional - only required for `covars_make_pos()` function
* Updated all function calls for quanteda v4 API compatibility
* Minimum R version now 4.0.0 (up from 3.2)

## New Features

* Improved error messages with installation instructions when optional dependencies missing
* Better documentation of spacyr requirement
* More robust handling of edge cases in snippet creation
* Added examples that work without spacyr

## Bug Fixes

* Fixed corpus reshaping calls for quanteda v4
* Fixed tokenization calls for modern quanteda
* Corrected namespace imports for quanteda.textstats
* Fixed character counting in snippet filtering

## Documentation

* Complete rewrite of README with modern installation instructions
* Added migration guide from original package
* Clarified which functions require spacyr
* Updated all examples to work with quanteda v4

## Internal Changes

* Updated NAMESPACE with proper imports from quanteda.textstats
* Added quanteda.textstats to Imports (was implicit before)
* Moved spacyr to Suggests (was in Imports)
* Modern roxygen2 documentation (7.3.1)
* Updated license and maintainer information

---

# Original sophistication package (versions prior to 0.80.0)

For the complete history of the original package, see:
https://github.com/kbenoit/sophistication/blob/master/NEWS.md

## Last original version: sophistication 0.70

Changes prior to this fork are attributed to Kenneth Benoit, Kevin Munger, and Arthur Spirling.
