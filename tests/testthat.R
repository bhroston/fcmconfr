#' @srrstats {G5.2, G5.2a, G5.2b, G5.3, G5.4, G5.4a, G5.4b, G5.8, G5.8a, G5.8b,
#' G5.8c, G5.8d, G5.9, G5.9a, G5.9b, BS2.1a}
#' Demonstrated by package tests.
#' @srrstats {G5.5} Correctness tests ran with fixed seed used for all tests
#' @srrstats {EA6.0, EA6.0a, EA6.0b, EA6.0c, EA6.0d, EA6.0e} All return values
#' are sufficiently tested.
#' @srrstats {EA6.1} Graphical outputs are tested via using vdiffr
#' @noRd
NULL



# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/tests.html
# * https://testthat.r-lib.org/reference/test_package.html#special-files

library(testthat)
library(fcmconfr)

set.seed(12345)

test_check("fcmconfr")
