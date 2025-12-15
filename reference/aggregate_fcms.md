# Aggregate FCMs

Generate an aggregate adj. matrix from a list of adj. matrices. FCM
aggregation works by calculating the mean/median edge weight for all
edges across the input adj. matrices (i.e. the mean/median of the edge
weight connecting A -\> B across all maps, the mean/median of the edge
weight connecting B -\> C across all maps, and so on). The user may
dictate whether to incorporate 0-valued edge weights in the mean/median
calculations.

All input adj. matrices must have the same dimensions and concept names
to generate an aggregate. Call
[`standardize_adj_matrices`](https://bhroston.github.io/fcmconfr/reference/standardize_adj_matrices.md)
to make sure all adj. matrices have the same dimensions.

## Usage

``` r
aggregate_fcms(
  adj_matrices = list(),
  agg_function = c("mean", "median"),
  include_zeroes_in_sampling = FALSE,
  skip_checks = FALSE
)
```

## Arguments

- adj_matrices:

  \[[`list()`](https://rdrr.io/r/base/list.html)\]  
  A single adjacency matrix or a list of adjacency matrices (n x n)
  representing FCMs. Matrices can have conventional edge weights, IVFN
  edge weights or TFN edge weights.

- agg_function:

  \[`character(1)`\]  
  Choice of aggregation method (mean, median) for producing a single
  "collective" FCM from a group of individual FCMs. Omit this argument
  when analyzing a single FCM.

- include_zeroes_in_sampling:

  \[`logical(1)`\]  
  If TRUE, incorporate zero-weighted edges during FCM aggregation.

- skip_checks:

  \[`logical(1)`\]  
  FOR DEVELOPER USE ONLY. If TRUE, skip call to
  `check_simulation_inputs` (internal function)

## Value

\[`aggregate`\]  
An an aggregate adj. matrix with edges represented as the same data
types as the inputs (i.e. Numerics for, IVFNs, or TFNs)

## Details

This function implements FCM aggregation methods used in Aminpour 2020
(https://doi.org/10.1038/s41893-019-0467-z) for use with conventional
FCMs, and expands upon them for IVFN- and TFN-FCMs.

**Conventional FCMs**

The mean aggregate FCM of a set of conventional FCMs is: \$\$
\begin{array} {lcl} A\_{ij}^{aggregate} & = & \frac{\sum \_{p\\ =\\
1}^{N} A\_{ij}^{FCM\_{p}}}{N} \end{array} \$\$ where
\\A\_{ij}^{aggregate}\\ is the weight in the aggregate adjacency matrix
for the element in row i and column j, and \\FCM\_{p}\\ is the weight
for the element in row i and column j in the adjacency matrix of the
p-th FCM.

If not including zero-valued edges in aggregation calculations, the mean
aggregate equation becomes: \$\$ \begin{array} {lcl} A\_{ij}^{aggregate}
& = & \frac{\sum \_{p\\ =\\ 1}^{N} A\_{ij}^{FCM\_{p}}}{\sum \_{p\\ =\\
1}^{N} 1\|A\_{ij}^{FCM\_{p}} \neq 0} \end{array} \$\$

The median aggregate FCM of a set of conventional FCMs is: \$\$
\begin{array} {lcl} A\_{ij}^{aggregate} & = & \mathrm{Median}
(A\_{ij}^{FCM\_{1}} ,A\_{ij}^{FCM\_{2}} ,...,A\_{ij}^{FCM\_{N}} )\\
\end{array} \$\$ If not including zero-valued edges in aggregation
calculations, the median aggregate equation becomes: \$\$ \begin{array}
{lcl} A\_{ij}^{aggregate} & = & \mathrm{Median} (A\_{ij}^{FCM\_{1}}
,A\_{ij}^{FCM\_{2}} ,...,A\_{ij}^{FCM\_{N}} )\\ \|\\ A\_{ij}^{FCM\_{p}}
\neq 0 \end{array} \$\$

**IVFN-FCMs**

The mean aggregate FCM of a set of IVFN-FCMs is: \$\$ \begin{array}
{lcl} A\_{ij}^{aggregate} & = & \left\[ A^{L} ,A^{U} \\
\right\]\_{ij}^{FCM\_{aggregate}} \\ \\ & = & \left\[\frac{\sum \_{p\\
=\\ 1}^{N}\left\[ A^{L}\right\]\_{ij}^{FCM\_{p}}}{N} ,\\ \frac{\sum
\_{p\\ =\\ 1}^{N}\left\[ A^{U}\right\]\_{ij}^{FCM\_{p}}}{N}\right\]
\end{array} \$\$ where \\\left\[ A^{L} ,A^{U} \\
\right\]\_{ij}^{FCM\_{aggregate}}\\ is the IVFN weight (with lower bound
\\A^{L}\\ and upper bound \\A^{U}\\) of the element in row i and column
j of the aggregate, and \\\left\[ A^{L}\right\]\_{ij}^{FCM\_{p}}\\ and
\\\left\[ A^{L}\right\]\_{ij}^{FCM\_{p}}\\ are the lower and upper
bounds of the IVFN weight of the element in row i and column j for the
p-th FCM adjacency matrix.

If not including zero-valued edges in aggregation calculations, the mean
aggregate equation becomes: \$\$ \begin{array} {lcl} A\_{ij}^{aggregate}
& = & \left\[ A^{L} ,A^{U} \\ \right\]\_{ij}^{FCM\_{aggregate}} \\ \\ &
= & \left\[\frac{\sum \_{p\\ =\\ 1}^{N}\left\[
A^{L}\right\]\_{ij}^{FCM\_{p}}}{\sum \_{p\\ =\\ 1}^{N} 1\|\left\[
A^{L}\right\]\_{ij}^{FCM\_{p}} \neq 0} ,\\ \frac{\sum \_{p\\ =\\
1}^{N}\left\[ A^{U}\right\]\_{ij}^{FCM\_{p}}}{\sum \_{p\\ =\\ 1}^{N}
1\|\left\[ A^{U}\right\]\_{ij}^{FCM\_{p}} \neq 0}\right\] \end{array}
\$\$

The median aggregate FCM of a set of IVFN-FCMs is: \$\$ \begin{array}
{lcl} A\_{ij}^{aggregate} & = & \left\[ \\ \mathrm{Median}\left(
A\_{ij}^{FCM\_{1} -L} ,A\_{ij}^{FCM\_{2} -L} ,...,A\_{ij}^{FCM\_{N}
-L}\right) \right. , \\ & & \\ \\ \left. \mathrm{Median}\left(
A\_{ij}^{FCM\_{1} -U} ,A\_{ij}^{FCM\_{2} -U} ,...,A\_{ij}^{FCM\_{N}
-U}\right) \\ \right\] \end{array} \$\$

If not including zero-valued edges in aggregation calculations, the
median aggregate equation becomes: \$\$ \begin{array} {lcl}
A\_{ij}^{aggregate} & = & \left\[ \\ \mathrm{Median}\left(
A\_{ij}^{FCM\_{1} -L} ,A\_{ij}^{FCM\_{2} -L} ,...,A\_{ij}^{FCM\_{N}
-L}\right) \|A\_{ij}^{FCM\_{p} -L} \neq A\_{ij}^{FCM\_{p} -U} \neq 0
\right. , \\ & & \\ \\ \left. \mathrm{Median}\left( A\_{ij}^{FCM\_{1}
-U} ,A\_{ij}^{FCM\_{2} -U} ,...,A\_{ij}^{FCM\_{N} -U}\right)
\|A\_{ij}^{FCM\_{p} -L} \neq A\_{ij}^{FCM\_{p} -U} \neq 0 \\ \right\]
\end{array} \$\$

**TFN-FCMs**

The mean aggregate FCM of a set of TFN-FCMs is: \$\$ \begin{array} {lcl}
A\_{ij}^{aggregate} & = & \left\[ A^{L} ,A^{M} ,A^{U} \\
\right\]\_{ij}^{FCM\_{aggregate}} \\ \\ & = & \left\[\frac{\sum \_{p\\
=\\ 1}^{N}\left\[ A^{L}\right\]\_{ij}^{FCM\_{p}}}{N} ,\frac{\sum \_{p\\
=\\ 1}^{N}\left\[ A^{M}\right\]\_{ij}^{FCM\_{p}}}{N} ,\frac{\sum \_{p\\
=\\ 1}^{N}\left\[ A^{U}\right\]\_{ij}^{FCM\_{p}}}{N}\right\] \end{array}
\$\$

where \\\left\[ A^{L} , A^{M}, A^{U} \\
\right\]\_{ij}^{FCM\_{aggregate}}\\ is the TFN weight (with lower bound
\\A^{L}\\, mode \\A^{M}\\, and upper bound \\A^{U}\\) of the element in
row i and column j of the aggregate, and \\\left\[
A^{L}\right\]\_{ij}^{FCM\_{p}}\\, \\\left\[
A^{M}\right\]\_{ij}^{FCM\_{p}}\\, and \\\left\[
A^{U}\right\]\_{ij}^{FCM\_{p}}\\ are the lower bound, mode, and upper
bound of the TFN weight of the element in row i and column j for the
p-th FCM adjacency matrix.

If not including zero-valued edges in aggregation calculations, the mean
aggregate equation becomes: \$\$ \begin{array} {lcl} A\_{ij}^{aggregate}
& = & \left\[ A^{L} ,A^{M} ,A^{U} \\ \right\]\_{ij}^{FCM\_{aggregate}}
\\ \\ & = & \left\[\frac{\sum \_{p\\ =\\ 1}^{N}\left\[
A^{L}\right\]\_{ij}^{FCM\_{p}}}{\sum \_{p\\ =\\ 1}^{N} 1\|\left\[
A^{L}\right\]\_{ij}^{FCM\_{p}} \neq 0} ,\frac{\sum \_{p\\ =\\
1}^{N}\left\[ A^{M}\right\]\_{ij}^{FCM\_{p}}}{\sum \_{p\\ =\\ 1}^{N}
1\|\left\[ A^{M}\right\]\_{ij}^{FCM\_{p}} \neq 0} ,\\ \frac{\sum \_{p\\
=\\ 1}^{N}\left\[ A^{U}\right\]\_{ij}^{FCM\_{p}}}{\sum \_{p\\ =\\ 1}^{N}
1\|\left\[ A^{U}\right\]\_{ij}^{FCM\_{p}} \neq 0}\right\] \end{array}
\$\$

The median aggregate FCM of a set of TFN-FCMs is:

\$\$ \begin{array} {lcl} A\_{ij}^{aggregate} & = & \left\[ \\
\mathrm{Median}\left( A\_{ij}^{FCM\_{1} -L} ,A\_{ij}^{FCM\_{2} -L}
,...,A\_{ij}^{FCM\_{N} -L} \right) \right. , \\ & & \\ \\ \\
\mathrm{Median}\left( A\_{ij}^{FCM\_{1} -M} ,A\_{ij}^{FCM\_{2} -M}
,...,A\_{ij}^{FCM\_{N} -M}\right) , \\ & & \\ \\ \\ \left.
\mathrm{Median}\left( A\_{ij}^{FCM\_{1} -U} ,A\_{ij}^{FCM\_{2} -U}
,...,A\_{ij}^{FCM\_{N} -U}\right) \right\] \end{array} \$\$

If not including zero-valued edges in aggregation calculations, the
median aggregate equation becomes:

\$\$ \begin{array} {lcl} A\_{ij}^{aggregate} & = & \left\[ \\
\mathrm{Median}\left( A\_{ij}^{FCM\_{1} -L} ,A\_{ij}^{FCM\_{2} -L}
,...,A\_{ij}^{FCM\_{N} -L}\right) \|A\_{ij}^{FCM\_{1} -L} \neq
A\_{ij}^{FCM\_{1} -M} \neq A\_{ij}^{FCM\_{1} -U} \neq 0 \right. , \\ & &
\\ \\ \\ \mathrm{Median}\left( A\_{ij}^{FCM\_{1} -M} ,A\_{ij}^{FCM\_{2}
-M} ,...,A\_{ij}^{FCM\_{N} -M}\right) \|A\_{ij}^{FCM\_{1} -L} \neq
A\_{ij}^{FCM\_{1} -M} \neq A\_{ij}^{FCM\_{1} -U} \neq 0 , \\ & & \\ \\
\\ \left. \mathrm{Median}\left( A\_{ij}^{FCM\_{1} -U} ,A\_{ij}^{FCM\_{2}
-U} ,...,A\_{ij}^{FCM\_{N} -U}\right) \|A\_{ij}^{FCM\_{1} -L} \neq
A\_{ij}^{FCM\_{1} -M} \neq A\_{ij}^{FCM\_{1} -U} \neq 0\right\]
\end{array} \$\$

## References

Aminpour P, Gray SA, Jetter AJ, Introne JE, Singer A, Arlinghaus R
(2020). “Wisdom of Stakeholder Crowds in Complex Social–Ecological
Systems.” Nature Sustainability, 3(3), 191–199. ISSN 2398-9629,
[doi:10.1038/s41893-019-0467-z](https://doi.org/10.1038/s41893-019-0467-z).

## See also

Other aggregate_fcms:
[`print.aggregate()`](https://bhroston.github.io/fcmconfr/reference/print.aggregate.md)

## Examples

``` r
# Aggregate Conventional FCMs
aggregate_fcms(sample_fcms$simple_fcms$conventional_fcms,
               agg_function = "mean",
               include_zeroes_in_sampling = TRUE,
               skip_checks = FALSE)
#> Loading required namespace: Matrix
#>                                              Guidance.Docs.for.Salt.Management
#> Guidance.Docs.for.Salt.Management                                   0.00000000
#> Public.Education.Programs                                           0.01833333
#> Salts.Added.during.Water.Treatment                                  0.00000000
#> Salts.Added.by.Winter.Maintenance.Activities                        0.00000000
#> Ecosystem.Health                                                    0.00000000
#> Public.Awareness.of.Reservoir.Salinization                          0.00000000
#> Salinization.of.the.Reservoir                                       0.00000000
#>                                              Public.Education.Programs
#> Guidance.Docs.for.Salt.Management                           0.01666667
#> Public.Education.Programs                                   0.00000000
#> Salts.Added.during.Water.Treatment                          0.00000000
#> Salts.Added.by.Winter.Maintenance.Activities                0.00000000
#> Ecosystem.Health                                            0.00000000
#> Public.Awareness.of.Reservoir.Salinization                  0.00000000
#> Salinization.of.the.Reservoir                               0.00000000
#>                                              Salts.Added.during.Water.Treatment
#> Guidance.Docs.for.Salt.Management                                    0.00000000
#> Public.Education.Programs                                           -0.01666667
#> Salts.Added.during.Water.Treatment                                   0.00000000
#> Salts.Added.by.Winter.Maintenance.Activities                         0.00000000
#> Ecosystem.Health                                                     0.00000000
#> Public.Awareness.of.Reservoir.Salinization                           0.00000000
#> Salinization.of.the.Reservoir                                        0.00000000
#>                                              Salts.Added.by.Winter.Maintenance.Activities
#> Guidance.Docs.for.Salt.Management                                              -0.2836667
#> Public.Education.Programs                                                      -0.1300000
#> Salts.Added.during.Water.Treatment                                              0.0000000
#> Salts.Added.by.Winter.Maintenance.Activities                                    0.0000000
#> Ecosystem.Health                                                                0.0000000
#> Public.Awareness.of.Reservoir.Salinization                                      0.0000000
#> Salinization.of.the.Reservoir                                                   0.0000000
#>                                              Ecosystem.Health
#> Guidance.Docs.for.Salt.Management                  0.02333333
#> Public.Education.Programs                          0.00000000
#> Salts.Added.during.Water.Treatment                 0.00000000
#> Salts.Added.by.Winter.Maintenance.Activities       0.00000000
#> Ecosystem.Health                                   0.00000000
#> Public.Awareness.of.Reservoir.Salinization         0.00000000
#> Salinization.of.the.Reservoir                     -0.59033333
#>                                              Public.Awareness.of.Reservoir.Salinization
#> Guidance.Docs.for.Salt.Management                                           0.000000000
#> Public.Education.Programs                                                   0.000000000
#> Salts.Added.during.Water.Treatment                                          0.000000000
#> Salts.Added.by.Winter.Maintenance.Activities                                0.000000000
#> Ecosystem.Health                                                            0.000000000
#> Public.Awareness.of.Reservoir.Salinization                                  0.000000000
#> Salinization.of.the.Reservoir                                               0.006666667
#>                                              Salinization.of.the.Reservoir
#> Guidance.Docs.for.Salt.Management                             -0.081666667
#> Public.Education.Programs                                     -0.043333333
#> Salts.Added.during.Water.Treatment                             0.068666667
#> Salts.Added.by.Winter.Maintenance.Activities                   0.669333333
#> Ecosystem.Health                                              -0.003333333
#> Public.Awareness.of.Reservoir.Salinization                     0.000000000
#> Salinization.of.the.Reservoir                                  0.000000000
#> 
#> Aggregate (mean) of 30 adj. matrices

# Aggregate IVFN FCMs
aggregate_fcms(sample_fcms$simple_fcms$ivfn_fcms,
               agg_function = "mean",
               include_zeroes_in_sampling = TRUE,
               skip_checks = FALSE)
#>                                              Guidance.Docs.for.Salt.Management
#> Guidance.Docs.for.Salt.Management                                         0, 0
#> Public.Education.Programs                               0.00000000, 0.05833333
#> Salts.Added.during.Water.Treatment                                        0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                              0, 0
#> Ecosystem.Health                                                          0, 0
#> Public.Awareness.of.Reservoir.Salinization                                0, 0
#> Salinization.of.the.Reservoir                                             0, 0
#>                                              Public.Education.Programs
#> Guidance.Docs.for.Salt.Management             0.003333333, 0.030000000
#> Public.Education.Programs                                         0, 0
#> Salts.Added.during.Water.Treatment                                0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                      0, 0
#> Ecosystem.Health                                                  0, 0
#> Public.Awareness.of.Reservoir.Salinization                        0, 0
#> Salinization.of.the.Reservoir                                     0, 0
#>                                              Salts.Added.during.Water.Treatment
#> Guidance.Docs.for.Salt.Management                                          0, 0
#> Public.Education.Programs                            -0.030000000, -0.003333333
#> Salts.Added.during.Water.Treatment                                         0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                               0, 0
#> Ecosystem.Health                                                           0, 0
#> Public.Awareness.of.Reservoir.Salinization                                 0, 0
#> Salinization.of.the.Reservoir                                              0, 0
#>                                              Salts.Added.by.Winter.Maintenance.Activities
#> Guidance.Docs.for.Salt.Management                                  -0.4783333, -0.0920000
#> Public.Education.Programs                                        -0.23666667, -0.03666667
#> Salts.Added.during.Water.Treatment                                                   0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                         0, 0
#> Ecosystem.Health                                                                     0, 0
#> Public.Awareness.of.Reservoir.Salinization                                           0, 0
#> Salinization.of.the.Reservoir                                                        0, 0
#>                                                    Ecosystem.Health
#> Guidance.Docs.for.Salt.Management            0.01000000, 0.03333333
#> Public.Education.Programs                                      0, 0
#> Salts.Added.during.Water.Treatment                             0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                   0, 0
#> Ecosystem.Health                                               0, 0
#> Public.Awareness.of.Reservoir.Salinization                     0, 0
#> Salinization.of.the.Reservoir                -0.8666667, -0.2420000
#>                                              Public.Awareness.of.Reservoir.Salinization
#> Guidance.Docs.for.Salt.Management                                                  0, 0
#> Public.Education.Programs                                                          0, 0
#> Salts.Added.during.Water.Treatment                                                 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                       0, 0
#> Ecosystem.Health                                                                   0, 0
#> Public.Awareness.of.Reservoir.Salinization                                         0, 0
#> Salinization.of.the.Reservoir                                                0.00, 0.02
#>                                              Salinization.of.the.Reservoir
#> Guidance.Docs.for.Salt.Management                 -0.16166667, -0.01333333
#> Public.Education.Programs                       -0.096666667, -0.006666667
#> Salts.Added.during.Water.Treatment                    0.0000000, 0.1886667
#> Salts.Added.by.Winter.Maintenance.Activities                  0.291, 0.940
#> Ecosystem.Health                                   -0.01666667, 0.00000000
#> Public.Awareness.of.Reservoir.Salinization                            0, 0
#> Salinization.of.the.Reservoir                                         0, 0
#> 
#> Aggregate (mean) of 30 adj. matrices

# Aggregate TFN FCMs
aggregate_fcms(sample_fcms$simple_fcms$tfn_fcms,
               agg_function = "mean",
               include_zeroes_in_sampling = TRUE,
               skip_checks = FALSE)
#>                                               Guidance.Docs.for.Salt.Management
#> Guidance.Docs.for.Salt.Management                                       0, 0, 0
#> Public.Education.Programs                    0.00000000, 0.01833333, 0.05833333
#> Salts.Added.during.Water.Treatment                                      0, 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                            0, 0, 0
#> Ecosystem.Health                                                        0, 0, 0
#> Public.Awareness.of.Reservoir.Salinization                              0, 0, 0
#> Salinization.of.the.Reservoir                                           0, 0, 0
#>                                                          Public.Education.Programs
#> Guidance.Docs.for.Salt.Management            0.003333333, 0.016666667, 0.030000000
#> Public.Education.Programs                                                  0, 0, 0
#> Salts.Added.during.Water.Treatment                                         0, 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                               0, 0, 0
#> Ecosystem.Health                                                           0, 0, 0
#> Public.Awareness.of.Reservoir.Salinization                                 0, 0, 0
#> Salinization.of.the.Reservoir                                              0, 0, 0
#>                                                    Salts.Added.during.Water.Treatment
#> Guidance.Docs.for.Salt.Management                                             0, 0, 0
#> Public.Education.Programs                    -0.030000000, -0.016666667, -0.003333333
#> Salts.Added.during.Water.Treatment                                            0, 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                  0, 0, 0
#> Ecosystem.Health                                                              0, 0, 0
#> Public.Awareness.of.Reservoir.Salinization                                    0, 0, 0
#> Salinization.of.the.Reservoir                                                 0, 0, 0
#>                                              Salts.Added.by.Winter.Maintenance.Activities
#> Guidance.Docs.for.Salt.Management                      -0.4783333, -0.2836667, -0.0920000
#> Public.Education.Programs                           -0.23666667, -0.13000000, -0.03666667
#> Salts.Added.during.Water.Treatment                                                0, 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                      0, 0, 0
#> Ecosystem.Health                                                                  0, 0, 0
#> Public.Awareness.of.Reservoir.Salinization                                        0, 0, 0
#> Salinization.of.the.Reservoir                                                     0, 0, 0
#>                                                                Ecosystem.Health
#> Guidance.Docs.for.Salt.Management            0.01000000, 0.02333333, 0.03333333
#> Public.Education.Programs                                               0, 0, 0
#> Salts.Added.during.Water.Treatment                                      0, 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                            0, 0, 0
#> Ecosystem.Health                                                        0, 0, 0
#> Public.Awareness.of.Reservoir.Salinization                              0, 0, 0
#> Salinization.of.the.Reservoir                -0.8666667, -0.5903333, -0.2420000
#>                                              Public.Awareness.of.Reservoir.Salinization
#> Guidance.Docs.for.Salt.Management                                               0, 0, 0
#> Public.Education.Programs                                                       0, 0, 0
#> Salts.Added.during.Water.Treatment                                              0, 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                    0, 0, 0
#> Ecosystem.Health                                                                0, 0, 0
#> Public.Awareness.of.Reservoir.Salinization                                      0, 0, 0
#> Salinization.of.the.Reservoir                     0.000000000, 0.006666667, 0.020000000
#>                                                         Salinization.of.the.Reservoir
#> Guidance.Docs.for.Salt.Management               -0.16166667, -0.08166667, -0.01333333
#> Public.Education.Programs                    -0.096666667, -0.043333333, -0.006666667
#> Salts.Added.during.Water.Treatment                 0.00000000, 0.06866667, 0.18866667
#> Salts.Added.by.Winter.Maintenance.Activities          0.2910000, 0.6693333, 0.9400000
#> Ecosystem.Health                              -0.016666667, -0.003333333, 0.000000000
#> Public.Awareness.of.Reservoir.Salinization                                    0, 0, 0
#> Salinization.of.the.Reservoir                                                 0, 0, 0
#> 
#> Aggregate (mean) of 30 adj. matrices

# NOTE: If the lower bound of an edge weight is 0, but the upper bound is > 0,
# the assumption that a stakeholder simply did not include the edge is invalid.
# Thus, since the 0-lower bound is meaningful, it is included in mean/median
# calculations even if include_zeroes = FALSE
aggregate_fcms(sample_fcms$simple_fcms$ivfn_fcms, "mean", include_zeroes_in_sampling = FALSE)
#>                                              Guidance.Docs.for.Salt.Management
#> Guidance.Docs.for.Salt.Management                                         0, 0
#> Public.Education.Programs                                 0.0000000, 0.5833333
#> Salts.Added.during.Water.Treatment                                        0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                              0, 0
#> Ecosystem.Health                                                          0, 0
#> Public.Awareness.of.Reservoir.Salinization                                0, 0
#> Salinization.of.the.Reservoir                                             0, 0
#>                                              Public.Education.Programs
#> Guidance.Docs.for.Salt.Management                             0.1, 0.9
#> Public.Education.Programs                                         0, 0
#> Salts.Added.during.Water.Treatment                                0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                      0, 0
#> Ecosystem.Health                                                  0, 0
#> Public.Awareness.of.Reservoir.Salinization                        0, 0
#> Salinization.of.the.Reservoir                                     0, 0
#>                                              Salts.Added.during.Water.Treatment
#> Guidance.Docs.for.Salt.Management                                          0, 0
#> Public.Education.Programs                                            -0.9, -0.1
#> Salts.Added.during.Water.Treatment                                         0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                               0, 0
#> Ecosystem.Health                                                           0, 0
#> Public.Awareness.of.Reservoir.Salinization                                 0, 0
#> Salinization.of.the.Reservoir                                              0, 0
#>                                              Salts.Added.by.Winter.Maintenance.Activities
#> Guidance.Docs.for.Salt.Management                                  -0.8441176, -0.1623529
#> Public.Education.Programs                                          -0.7888889, -0.1222222
#> Salts.Added.during.Water.Treatment                                                   0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                         0, 0
#> Ecosystem.Health                                                                     0, 0
#> Public.Awareness.of.Reservoir.Salinization                                           0, 0
#> Salinization.of.the.Reservoir                                                        0, 0
#>                                                    Ecosystem.Health
#> Guidance.Docs.for.Salt.Management                          0.3, 1.0
#> Public.Education.Programs                                      0, 0
#> Salts.Added.during.Water.Treatment                             0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                   0, 0
#> Ecosystem.Health                                               0, 0
#> Public.Awareness.of.Reservoir.Salinization                     0, 0
#> Salinization.of.the.Reservoir                -0.8965517, -0.2503448
#>                                              Public.Awareness.of.Reservoir.Salinization
#> Guidance.Docs.for.Salt.Management                                                  0, 0
#> Public.Education.Programs                                                          0, 0
#> Salts.Added.during.Water.Treatment                                                 0, 0
#> Salts.Added.by.Winter.Maintenance.Activities                                       0, 0
#> Ecosystem.Health                                                                   0, 0
#> Public.Awareness.of.Reservoir.Salinization                                         0, 0
#> Salinization.of.the.Reservoir                                                  0.0, 0.6
#>                                              Salinization.of.the.Reservoir
#> Guidance.Docs.for.Salt.Management                 -0.80833333, -0.06666667
#> Public.Education.Programs                                   -0.725, -0.050
#> Salts.Added.during.Water.Treatment                    0.0000000, 0.6288889
#> Salts.Added.by.Winter.Maintenance.Activities                  0.291, 0.940
#> Ecosystem.Health                                                 -0.5, 0.0
#> Public.Awareness.of.Reservoir.Salinization                            0, 0
#> Salinization.of.the.Reservoir                                         0, 0
#> 
#> Aggregate (mean) of 30 adj. matrices
```
