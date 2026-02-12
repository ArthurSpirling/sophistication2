library(testthat)
library(sophistication2)

test_that("snippets_make creates snippets correctly", {
    corp <- quanteda::corpus(c(
        d1 = "This is sentence one. This is sentence two. This is sentence three.",
        d2 = "Another document here. With multiple sentences for testing."
    ))
    
    snippets <- snippets_make(corp, nsentence = 1, minchar = 10, maxchar = 100)
    
    expect_true(is.data.frame(snippets))
    expect_true("text" %in% names(snippets))
    expect_true("docID" %in% names(snippets))
    expect_true("snippetID" %in% names(snippets))
    expect_true(nrow(snippets) > 0)
})

test_that("snippets_clean removes problematic snippets", {
    snippets <- data.frame(
        docID = c("d1", "d2", "d3", "d4"),
        snippetID = c("s1", "s2", "s3", "s4"),
        text = c(
            "Normal text here.",
            "ALL CAPS TITLE TEXT",
            "The year 2024 was fine.",
            "In 1999 there were issues."
        ),
        stringsAsFactors = FALSE
    )
    
    cleaned <- snippets_clean(snippets, verbose = FALSE)
    
    expect_true(is.data.frame(cleaned))
    expect_lt(nrow(cleaned), nrow(snippets))
    # Should have removed ALL CAPS
    expect_false("ALL CAPS TITLE TEXT" %in% cleaned$text)
})

test_that("pairs_regular_make creates pairs", {
    snippets <- data.frame(
        docID = paste0("d", 1:5),
        snippetID = paste0("s", 1:5),
        text = paste("Text number", 1:5),
        stringsAsFactors = FALSE
    )
    
    pairs <- pairs_regular_make(snippets, n.pairs = 3)
    
    expect_true(is.data.frame(pairs))
    expect_equal(nrow(pairs), 3)
    expect_true("text1" %in% names(pairs))
    expect_true("text2" %in% names(pairs))
})

test_that("bootstrap_readability computes statistics", {
    skip_if_not_installed("quanteda.textstats")
    
    txt <- c(
        "This is a simple sentence.",
        "This sentence is more complex with additional words and clauses."
    )
    
    result <- bootstrap_readability(txt, measure = "Flesch", n = 10, verbose = FALSE)
    
    expect_type(result, "list")
    expect_true("mean" %in% names(result))
    expect_true("se" %in% names(result))
    expect_true(is.numeric(result$mean))
    expect_true(is.numeric(result$se))
})

test_that("covars_make computes basic features", {
    txt <- c("Simple text.", "More complex text with many words here.")
    
    covars <- covars_make(txt)
    
    expect_true(is.data.frame(covars))
    expect_true("n_tokens" %in% names(covars))
    expect_true("ttr" %in% names(covars))
    expect_equal(nrow(covars), 2)
})

test_that("pairs_gold_make creates gold pairs", {
    skip_if_not_installed("quanteda.textstats")
    
    # Create snippets with very different complexity
    snippets <- data.frame(
        docID = paste0("d", 1:10),
        snippetID = paste0("s", 1:10),
        text = c(
            "Simple.",
            "Complex sentence with multiple subordinate clauses and sophisticated vocabulary.",
            rep("Medium text here with some words.", 8)
        ),
        stringsAsFactors = FALSE
    )
    
    pairs <- pairs_regular_make(snippets, n.pairs = 20)
    gold <- pairs_gold_make(pairs, n.pairs = 3)
    
    expect_true(is.data.frame(gold))
    expect_equal(nrow(gold), 3)
    expect_true("_golden" %in% names(gold))
    expect_true(all(gold$`_golden`))
})
