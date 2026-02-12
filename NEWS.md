# sophistication2 0.80.0

## Major Changes

* **BREAKING**: Package renamed to `sophistication2` to distinguish from original
* **BREAKING**: Now requires quanteda >= 4.0.0 (up from 2.x)
* **BREAKING**: Readability functions now use `quanteda.textstats::textstat_readability()`
* Made spacyr truly optional - only required for `covars_make_pos()` function
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
