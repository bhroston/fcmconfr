# sample_fcms

An collection of FCM datasets based on stakeholder perceptions of rising
salinization of a local reservoir in a socio-ecological system. This
collection is separated into two sub-collections: one with larger FCMs
that incorporate over 40 nodes, and one with smaller, simpler FCMs that
greatly reduce the number of nodes (n = 7) per map. The sub-collection
of smaller, simplified FCMs is included to hasten testing.

## Usage

``` r
sample_fcms
```

## Format

### `sample_fcms`

A collection of simple and large FCMs with conventional, ivfn, and tfn
edge types

## Details

\$simple_fcms: these FCMs are filtered versions of the larger FCMs which
only include the following nodes, Guidance.Docs.for.Salt.Management,
Public.Education.Programs, Salts.Added.during.Water.Treatment,
Salts.Added.by.Winter.Maintenance.Activities, Ecosystem.Health,
Public.Awareness.of.Reservoir.Salinization, and
Salinization.of.the.Reservoir. (Renamd, but based on nodes in larger
FCMs)

- \$conventional_fcms: A list of smaller, simplified conventional FCMs

- \$ivfn_fcms: A list of smaller, simplified ivfn FCMs

- \$tfn_fcms: A list of smaller, simplified tfn FCMs \$large_fcms: these
  FCMs are large (n \> 40) and will likely increase runtimes but
  represent a more complete dataset

- \$conventional_fcms: A list of large conventional FCMs

- \$ivfn_fcms: A list of large ivfn FCMs

- \$tfn_fcms: A list of large tfn FCMs

Given in Rippy et al, (In Review); Not all stakeholder FCMs used here.
