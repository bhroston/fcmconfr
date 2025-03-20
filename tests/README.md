---
title: "README"
output: html_document
---

Running extended tests

The testthat directory contains several long-running tests which are not run by 
default. Running all of these tests can take several hours on an ordinary 
laptop. These tests can be switched on by defining an environmental variables 
FCMCONFR_EXTENDED_TESTS = "true" (e.g., Sys.setenv("FCMCONFR_EXTENDED_TESTS" = "true") 
in R), and on GitHub Actions by adding run-extended and run-scaling to the 
commit message respectively.
