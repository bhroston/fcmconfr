# Estimate lambda

This function calculates the largest possible lambda for sigmoid and
tanh squashing functions that guarantees convergence of an FCM
simulation. Lambda is estimated such that 'squashed' simulation values
are contained within the near-linear region of the sigmoid or tanh
functions.

Note: The lambda value estimated will vary for different FCMs.

This algorithm is intended for conventional FCMs. If an Interval Value
Fuzzy Number (IVFN) FCM or a Triangular Fuzzy Number (TFN) FCM is
provided, `estimate_fcm_lambda()` will create a conventional FCM by
averaging the edge weights (upper and lower for IVFN-FCMs; and upper,
mode, and lower for TFN-FCMs) for use in calculating lambda,

## Usage

``` r
estimate_fcm_lambda(
  adj_matrix = data.frame(),
  squashing = c("sigmoid", "tanh")
)
```

## Arguments

- adj_matrix:

  \[`list() or data.frame()`\]  
  A single adjacency matrix (n x n) representing FCMs. An adjacency
  matrix can have conventional edge weights, IVFN edge weights or TFN
  edge weights.

- squashing:

  \[`character(1)`\]  
  The squashing function used. Must be one of the following: 'tanh' or
  'sigmoid'.

## Value

\[`double(1)`\]  
The maximum lambda that ensures simulation convergence for the input
FCM.

## Details

This algorithm was first developed in Kottas et al. 2010
(https://doi.org/10.1007/978-3-642-03220-2_5), and expanded upon by
Harmati et al. 2018 (https://doi.org/10.1109/FUZZ-IEEE.2018.8491447),
and Koutsellis et al. 2022 (https://doi.org/10.1007/s12351-022-00717-x)

The function applies an algorithm that can be used to optimize lambda.
It compares the lambda calculated based on the Frobenius-norm
(\\\lambda^{'}\\) and S-norm (\\\lambda^{\*}\\) of an adjacency matrix
and selects the minimum.

\$\$ \lambda \_{s} \< \min\left( \lambda \_{s}^{'} ,\lambda
\_{s}^{\*}\right) \$\$ \$\$ \lambda \_{h} \< \min\left( \lambda
\_{h}^{'} ,\lambda \_{h}^{\*}\right) \$\$

where \\\lambda \_{s}\\ is the lambda calculation when using the sigmoid
squashing function and \\\lambda \_{h}\\ is the lambda calculation when
using tanh.

The equations for \\\lambda ^{'}\\ were developed by Harmati et al. 2018
(https://doi.org/10.1109/FUZZ-IEEE.2018.8491447) and are given below.

\$\$ \lambda \_{s} \< \lambda \_{s}^{'} =\frac{4}{\\ \mathbf{W} \\
\_{F}} \$\$

\$\$ \lambda \_{h} \< \lambda \_{h}^{'} =\frac{1}{\\ \mathbf{W} \\
\_{F}} \$\$

where \\\\ \mathbf{W} \\ \_{F} \\ =\\ \sqrt{\sum\limits
\_{i=1}^{n}\sum\limits \_{j=1}^{n}\left( w\_{ij}^{2}\right)}\\ is the
Frobenius norm of the adj. matrix (or `norm(x, type = "F")`).

The equations for \\\lambda ^{\*}\\ were developed by Koutsellis et al.
2022 (https://doi.org/10.1007/s12351-022-00717-x). Unlike for \\\lambda
^{'}\\, the calculations for \\\lambda ^{\*}\\ follow different steps
based on whether calculating \\\lambda\\ for the sigmoid or tanh
squashing function.

For sigmoid: \$\$ \|x\_{i}^{k} \\ \_{\max} =\max\left(\left\| 0.211\cdot
\sum \_{i=1}^{p} w\_{ij}^{+} +0.789\cdot \sum \_{i=1}^{p}
w\_{ij}^{-}\right\| ,\left\| 0.211\cdot \sum \_{i=1}^{p} w\_{ij}^{-}
+0.789\cdot \sum \_{i=1}^{p} w\_{ij}^{+}\right\| \right) \$\$ \$\$ \\
\mathbf{W} \\ \_{s} =\underset{i}{\max}\left( \|x\_{i}^{k} \\
\_{\max}\right) \$\$ \$\$ \lambda \_{s} \< \lambda \_{s}^{\*}
=\frac{1.317}{\\ \mathbf{W} \\ \_{s}} \$\$

For tanh: \$\$ \lambda \_{h} \< \lambda \_{h}^{\*} =\frac{1}{\\
\mathbf{W} \\ \_{\infty }} \$\$ \$\$ \\ \mathbf{W} \\ \_{\infty }
=\underset{i}{\max}\sum \_{j=1}^{n}\| w\_{ij}\| \$\$

Finally, the maximum lambda that ensures convergence of the simulation
for the input adjacency matrix is the minimum of \\\lambda ^{'}\\ and
\\\lambda ^{\*}\\.

Note: This is only algorithm included at present, but the code for
`estimate_fcm_lambda` is organized to streamline the addition of new
algorithms in the future.

## References

Kottas TL, Boutalis YS, Christodoulou MA (2010). “Fuzzy cognitive
networks: Adaptive network estimation and control paradigms.” In
Kacprzyk J, Glykas M (eds.), Fuzzy Cognitive Maps, volume 247, 89–134.
Springer Berlin Heidelberg, Berlin, Heidelberg. ISBN 978-3-642-03219-6
978-3-642-03220-2,
[doi:10.1007/978-3-642-03220-2_5](https://doi.org/10.1007/978-3-642-03220-2_5),
Series Title: Studies in Fuzziness and Soft Computing,

Harmati IA, Koczy LT (2018). “On the Existence and Uniqueness of Fixed
Points of Fuzzy Set Valued Sigmoid Fuzzy Cognitive Maps.” In 2018 IEEE
International Conference on Fuzzy Systems (FUZZ-IEEE), 1–7. ISBN
9781509060207,
[doi:10.1109/FUZZ-IEEE.2018.8491447](https://doi.org/10.1109/FUZZ-IEEE.2018.8491447),

Koutsellis T, Xexakis G, Koasidis K, Nikas A, Doukas H (2022).
“Parameter analysis for sigmoid and hyperbolic transfer functions of
fuzzy cognitive maps.” Operational Research, 22(5), 5733–5763. ISSN
1109-2858, 1866-1505,
[doi:10.1007/s12351-022-00717-x](https://doi.org/10.1007/s12351-022-00717-x),

## Examples

``` r

estimate_fcm_lambda(sample_fcms$simple_fcms$conventional_fcms[[1]], squashing = "sigmoid")
#> [1] 2.225602

estimate_fcm_lambda(sample_fcms$simple_fcms$ivfn_fcms[[1]], squashing = "tanh")
#> [1] 0.9186304

estimate_fcm_lambda(sample_fcms$simple_fcms$tfn_fcms[[1]], squashing = "sigmoid")
#> [1] 2.384574
```
