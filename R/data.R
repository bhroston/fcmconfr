

#' sample_fcms
#'
#' An collection of FCM datasets based on stakeholder perceptions of rising
#' salinization of a local reservoir in a socio-ecological system. This
#' collection is separated into two sub-collections: one with larger FCMs that
#' incorporate over 40 nodes, and one with smaller, simpler FCMs that greatly
#' reduce the number of nodes (n = 7) per map. The sub-collection of smaller,
#' simplified FCMs is included to hasten testing.
#'
#' $simple_fcms: these FCMs are filtered versions of the larger FCMs which
#' only include the following nodes, Guidance.Docs.for.Salt.Management,
#' Public.Education.Programs, Salts.Added.during.Water.Treatment,
#' Salts.Added.by.Winter.Maintenance.Activities, Ecosystem.Health,
#' Public.Awareness.of.Reservoir.Salinization, and
#' Salinization.of.the.Reservoir. (Renamd, but based on nodes in larger FCMs)
#'  - $conventional_fcms: A list of smaller, simplified conventional FCMs
#'  - $ivfn_fcms: A list of smaller, simplified ivfn FCMs
#'  - $tfn_fcms: A list of smaller, simplified tfn FCMs
#' $large_fcms: these FCMs are large (n > 40) and will likely increase runtimes
#' but represent a more complete dataset
#'  - $conventional_fcms: A list of large conventional FCMs
#'  - $ivfn_fcms: A list of large ivfn FCMs
#'  - $tfn_fcms: A list of large tfn FCMs
#'
#' Given in Rippy et al, (In Review); Not all stakeholder FCMs used here.
#'
#' @format ## `sample_fcms`
#' A collection of simple and large FCMs with conventional, ivfn, and tfn
#' edge types
#'
#' @srrstats {G5.1} *Data sets created within, and used to test, a package should be exported (or otherwise made generally available) so that users can confirm tests and run examples.*
#'
"sample_fcms"


#'
#' #' salinization_conventional_fcms
#' #'
#' #' An example fcm dataset collected by collecting stakeholder perceptions of
#' #' rising salinization in a socio-ecological system. To reduce file size and
#' #' protect stakeholder anonymity, the provided adjacency matrices contain a
#' #' subset of nodes and edges across the data used in the cited paper.
#' #'
#' #' Given in Rippy et al, (In Review)
#' #'
#' #' @format ## `salinization_conventional_fcms`
#' #' A list of conventional fcm adjacency matrices
#' #'
#' "salinization_conventional_fcms"
#'
#' #' salinization_ivfn_fcms
#' #'
#' #' An example fcm dataset collected by collecting stakeholder perceptions of
#' #' rising salinization in a socio-ecological system. To reduce file size and
#' #' protect stakeholder anonymity, the provided adjacency matrices contain a
#' #' subset of nodes and edges across the data used in the cited paper.
#' #'
#' #' A buffer has been added to each edge weight so that they may be represented
#' #' as interval-value fuzzy numbers (IVFNs) instead of discrete numerical
#' #' values. The edge weight of the original, conventional fcms is contained
#' #' within the domain of all IVFN edge weights to allow for comparison.
#' #'
#' #' Given in Rippy et al, (In Review)
#' #'
#' #' @format ## `salinization_ivfn_fcms`
#' #' A list of conventional fcm adjacency matrices
#' #'
#' "salinization_ivfn_fcms"
#'
#' #' salinization_tfn_fcms
#' #'
#' #' An example fcm dataset collected by collecting stakeholder perceptions of
#' #' rising salinization in a socio-ecological system. To reduce file size and
#' #' protect stakeholder anonymity, the provided adjacency matrices contain a
#' #' subset of nodes and edges across the data used in the cited paper.
#' #'
#' #' A buffer has been added to each edge weight so that they may be represented
#' #' as triangular-value fuzzy numbers (TFNs) instead of discrete numerical
#' #' values. The edge weight of the original, conventional fcms is contained
#' #' as the mode value of all TFN edge weights to allow for comparison.
#' #'
#' #' Given in Rippy et al, (In Review)
#' #'
#' #' @format ## `salinization_tfn_fcms`
#' #' A list of conventional fcm adjacency matrices
#' #'
#' "salinization_tfn_fcms"
#'
#' #' OLD! salinization_conventional_fcms
#' #'
#' #' An example fcm dataset collected by collecting stakeholder perceptions of
#' #' rising salinization in a socio-ecological system. To reduce file size and
#' #' protect stakeholder anonymity, the provided adjacency matrices contain a
#' #' subset of nodes and edges across the data used in the cited paper.
#' #'
#' #' Given in Rippy et al, (In Review)
#' #'
#' #' @format ## `salinization_conventional_fcms`
#' #' A list of conventional fcm adjacency matrices
#' #'
#' "old_salinization_conventional_fcms"
#'
#' #' OLD! salinization_ivfn_fcms
#' #'
#' #' An example fcm dataset collected by collecting stakeholder perceptions of
#' #' rising salinization in a socio-ecological system. To reduce file size and
#' #' protect stakeholder anonymity, the provided adjacency matrices contain a
#' #' subset of nodes and edges across the data used in the cited paper.
#' #'
#' #' A buffer has been added to each edge weight so that they may be represented
#' #' as interval-value fuzzy numbers (IVFNs) instead of discrete numerical
#' #' values. The edge weight of the original, conventional fcms is contained
#' #' within the domain of all IVFN edge weights to allow for comparison.
#' #'
#' #' Given in Rippy et al, (In Review)
#' #'
#' #' @format ## `salinization_ivfn_fcms`
#' #' A list of conventional fcm adjacency matrices
#' #'
#' "old_salinization_ivfn_fcms"
#'
#' #' OLD! salinization_tfn_fcms
#' #'
#' #' An example fcm dataset collected by collecting stakeholder perceptions of
#' #' rising salinization in a socio-ecological system. To reduce file size and
#' #' protect stakeholder anonymity, the provided adjacency matrices contain a
#' #' subset of nodes and edges across the data used in the cited paper.
#' #'
#' #' A buffer has been added to each edge weight so that they may be represented
#' #' as triangular-value fuzzy numbers (TFNs) instead of discrete numerical
#' #' values. The edge weight of the original, conventional fcms is contained
#' #' as the mode value of all TFN edge weights to allow for comparison.
#' #'
#' #' Given in Rippy et al, (In Review)
#' #'
#' #' @format ## `salinization_tfn_fcms`
#' #' A list of conventional fcm adjacency matrices
#' #'
#' "old_salinization_tfn_fcms"
#'
#' #' Vat FGCM Examples
#' #'
#' #' An example fgcm representing a multi-tank vat system. Depicted in
#' #' Salmeron & Papageorgiou, 2014 - https://doi.org/10.1007/s10489-013-0511-z
#' #'
#' #' @format ## `vat_fgcm_examples`
#' #' A list of fgcm adjacency matrices and initial state vectors
#' #' \describe{
#' #'   \item{fcm_as_fgcm}{An fgcm where every value is a white number to allow
#' #'   users to compare results with ordinary fcm}
#' #'   \item{fgcm}{An fgcm with grey values incorporated in its adjacency matrix}
#' #'   ...
#' #' }
#' #' @source <https://doi.org/10.1007/s10489-013-0511-z>
#' "vat_fgcm_examples"
