# Package index

## fcmconfr Core Functions

Core functions of the fcmconfr package. Users will be able to navigate
the key features of the package with these functions

- [`fcmconfr()`](https://bhroston.github.io/fcmconfr/reference/fcmconfr.md)
  : fcmconfr
- [`fcmconfr_gui()`](https://bhroston.github.io/fcmconfr/reference/fcmconfr_gui.md)
  : fcmconfr_gui
- [`get_fcmconfr_inferences()`](https://bhroston.github.io/fcmconfr/reference/get_fcmconfr_inferences.md)
  : Get inferences from an fcmconfr output

## fcmconfr Visualization and Summarization

Functions to display the information from fcmconfr outputs

- [`plot(`*`<fcmconfr>`*`)`](https://bhroston.github.io/fcmconfr/reference/plot.fcmconfr.md)
  : Plot fcmconfr
- [`print(`*`<fcmconfr>`*`)`](https://bhroston.github.io/fcmconfr/reference/print.fcmconfr.md)
  : print.fcmconfr
- [`summary(`*`<fcmconfr>`*`)`](https://bhroston.github.io/fcmconfr/reference/summary.fcmconfr.md)
  : summary.fcmconfr
- [`print(`*`<summary.fcmconfr>`*`)`](https://bhroston.github.io/fcmconfr/reference/print.summary.fcmconfr.md)
  : print.summary.fcmconfr

## FCM Inference

Functions called by fcmconfr() (and that may be used outside the
fcmconfr() function) that simulate inferences of individual FCM or a set
of FCMs.

- [`infer_fcm()`](https://bhroston.github.io/fcmconfr/reference/infer_fcm.md)
  : Infer FCM
- [`infer_fcm_set()`](https://bhroston.github.io/fcmconfr/reference/infer_fcm_set.md)
  : Infer Multiple FCMs in a List
- [`estimate_fcm_lambda()`](https://bhroston.github.io/fcmconfr/reference/estimate_fcm_lambda.md)
  : Estimate lambda

## FCM Aggregation

Functions called by fcmconfr() (and that may be used outside the
fcmconfr() function) that manage FCM aggregation.

- [`aggregate_fcms()`](https://bhroston.github.io/fcmconfr/reference/aggregate_fcms.md)
  : Aggregate FCMs
- [`print(`*`<aggregate>`*`)`](https://bhroston.github.io/fcmconfr/reference/print.aggregate.md)
  : Print method for aggregate

## Monte Carlo FCMs

Functions called by fcmconfr() (and that may be used outside the
fcmconfr() function) that manage the construction of Monte Carlo FCMs.

- [`build_monte_carlo_fcms()`](https://bhroston.github.io/fcmconfr/reference/build_monte_carlo_fcms.md)
  : Build Monte Carlo FCMs

## IVFN FCM Functions

Functions called by fcmconfr() (and that may be used outside the
fcmconfr() function) that manage Interval Value Fuzzy Numbers (IVFNs)
and FCMs which represent edge weights using IVFNs (IVFN FCMs)

- [`ivfn()`](https://bhroston.github.io/fcmconfr/reference/ivfn.md) :
  Interval-Valued Fuzzy Number (IVFN) - S3 Class
- [`c(`*`<ivfn>`*`)`](https://bhroston.github.io/fcmconfr/reference/c.ivfn.md)
  : c.ivfn
- [`print(`*`<ivfn>`*`)`](https://bhroston.github.io/fcmconfr/reference/print.ivfn.md)
  : Print an Interval-Valued Fuzzy Number (IVFN) - S3 Class
- [`create_ivfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_ivfn_fcm_from_conventional_fcm.md)
  : Create IVFN-FCM from Conventional FCM
- [`make_adj_matrix_w_ivfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_ivfns.md)
  : Create Adj. Matrix w/ Edges Represented as IVFNs
- [`subtract_ivfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_ivfn.md)
  : IVFN Subtraction (Interval Calculus)

## TFN FCM Functions

Functions called by fcmconfr() (and that may be used outside the
fcmconfr() function) that manage Triangular Fuzzy Numbers (TFNs) and
FCMs which represent edge weights using TFNs (TFN FCMs)

- [`tfn()`](https://bhroston.github.io/fcmconfr/reference/tfn.md) :
  Triangular Fuzzy Number (TFN) - S3 Class
- [`c(`*`<tfn>`*`)`](https://bhroston.github.io/fcmconfr/reference/c.tfn.md)
  : c.tfn
- [`print(`*`<tfn>`*`)`](https://bhroston.github.io/fcmconfr/reference/print.tfn.md)
  : Print a Triangular Fuzzy Number (TFN)
- [`create_tfn_fcm_from_conventional_fcm()`](https://bhroston.github.io/fcmconfr/reference/create_tfn_fcm_from_conventional_fcm.md)
  : Create TFN-FCM from Conventional FCM
- [`make_adj_matrix_w_tfns()`](https://bhroston.github.io/fcmconfr/reference/make_adj_matrix_w_tfns.md)
  : Create Adj. Matrix w/ Edges Represented as TFNs
- [`subtract_tfn()`](https://bhroston.github.io/fcmconfr/reference/subtract_tfn.md)
  : TFN Subtraction (Interval Calculus)
- [`rtriangular_dist()`](https://bhroston.github.io/fcmconfr/reference/rtriangular_dist.md)
  : The Triangular Distribution
- [`plot(`*`<rtriangular_dist>`*`)`](https://bhroston.github.io/fcmconfr/reference/plot.rtriangular_dist.md)
  : plot.rtriangular_dist

## Utility Functions

Additional helper functions

- [`fcm_view()`](https://bhroston.github.io/fcmconfr/reference/fcm_view.md)
  : View FCM Network
- [`defuzz_ivfn_or_tfn()`](https://bhroston.github.io/fcmconfr/reference/defuzz_ivfn_or_tfn.md)
  : Defuzz (IVFN or TFN)
- [`standardize_adj_matrices()`](https://bhroston.github.io/fcmconfr/reference/standardize_adj_matrices.md)
  : Standardize a List of Adjacency Matrices

## Sample Data Included in the Package

A list of two sets of FCMs: \> 1) Small FCMs (7 nodes) - Conventional,
IVFN, and TFN FCMs 2) Large FCMs (46 nodes) - Conventional, IVFN, and
TFN FCMs

- [`sample_fcms`](https://bhroston.github.io/fcmconfr/reference/sample_fcms.md)
  : sample_fcms
