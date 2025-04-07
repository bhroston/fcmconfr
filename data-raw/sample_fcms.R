
filepath <- file.choose() # stkhldr_data

sheet_names <- readxl::excel_sheets(filepath)
stkhldrs <- sheet_names[sheet_names != "COORDS"]
n_removed <- 5
randomized_stkhldr_indexes <- sample(seq_along(stkhldrs), length(stkhldrs) - n_removed, replace = FALSE)
randomized_stkhldrs <- stkhldrs[randomized_stkhldr_indexes]

salinization_conventional_fcms <- lapply(
  randomized_stkhldrs, function(random_stkhldr) readxl::read_excel(filepath, sheet = random_stkhldr)
)

nodes_in_raw_fcms <- unique(lapply(salinization_ses_conventional_fcms, colnames))[[1]]
selected_nodes <- c(
  "Salinization.Watershed",
  "C:Winter.public",
  "A:Public.edu",
  "A:Guidance.docs",
  "C:DW.treatment",
  "FA:Healthy.ecosystem",
  "FA:Public.Awareness"
)
selected_nodes_indexes <- which(nodes_in_raw_fcms %in% selected_nodes)

simple_conventional_fcms <- lapply(salinization_conventional_fcms, function(fcm) fcm[selected_nodes_indexes, selected_nodes_indexes])
simple_conventional_fcms <- lapply(
  simple_conventional_fcms,
  function(simple_fcm) {
    colnames(simple_fcm) <- c(
      "Guidance.Docs.for.Salt.Management", "Public.Education.Programs", "Salts.Added.during.Water.Treatment",
      "Salts.Added.by.Winter.Maintenance.Activities", "Ecosystem.Health", "Public.Awareness.of.Reservoir.Salinization",
      "Salinization.of.the.Reservoir"
    )
    simple_fcm
  }
)

ivfn_and_tfn_buffer <- 0.4

# create_ivfn_fcm_from_conventional_fcm <- function(fcm, buffer) {
#   only_positive_values <- ifelse(all(fcm >= 0), TRUE, FALSE)
#   as.data.frame(apply(
#     fcm, c(1, 2),
#     function(element) {
#       if (element == 0) {
#         return(ivfn(0, 0))
#       }
#
#       try_lower <- element - buffer
#       if (only_positive_values & try_lower < 0) {
#         use_lower <- 0
#       } else if (!only_positive_values & try_lower < -1) {
#         use_lower <- -1
#       } else if (try_lower < 0 & element > 0) {
#         use_lower <- 0
#       } else {
#         use_lower <- try_lower
#       }
#
#       try_upper <- element + buffer
#       if (try_upper > 1) {
#         use_upper <- 1
#       } else if (try_upper > 0 & element < 0) {
#         use_upper <- 0
#       } else {
#         use_upper <- try_upper
#       }
#
#       ivfn(use_lower, use_upper)
#     }
#   ))
# }
complete_ivfn_fcms <- lapply(salinization_conventional_fcms, create_ivfn_fcm_from_conventional_fcm, error = ivfn_and_tfn_buffer)
simple_ivfn_fcms <- lapply(simple_conventional_fcms, create_ivfn_fcm_from_conventional_fcm, error = ivfn_and_tfn_buffer)

# create_sample_tfn_fcm_from_fcm <- function(fcm, buffer) {
#   only_positive_values <- ifelse(all(fcm >= 0), TRUE, FALSE)
#   as.data.frame(apply(
#     fcm, c(1, 2),
#     function(element) {
#       if (element == 0) {
#         return(tfn(0, 0, 0))
#       }
#
#       try_lower <- element - buffer
#       if (only_positive_values & try_lower < 0) {
#         use_lower <- 0
#       } else if (!only_positive_values & try_lower < -1) {
#         use_lower <- -1
#       } else if (try_lower < 0 & element > 0) {
#         use_lower <- 0
#       } else {
#         use_lower <- try_lower
#       }
#
#       try_upper <- element + buffer
#       if (try_upper > 1) {
#         use_upper <- 1
#       } else if (try_upper > 0 & element < 0) {
#         use_upper <- 0
#       } else {
#         use_upper <- try_upper
#       }
#
#       tfn(use_lower, element, use_upper)
#     }
#   ))
# }
complete_tfn_fcms <- lapply(salinization_conventional_fcms, create_sample_tfn_fcm_from_fcm, error = ivfn_and_tfn_buffer)
simple_tfn_fcms <- lapply(simple_conventional_fcms, create_sample_tfn_fcm_from_fcm, error = ivfn_and_tfn_buffer)

salinization_fcms <- list(
  conventional_fcms = salinization_conventional_fcms,
  ivfn_fcms = complete_ivfn_fcms,
  tfn_fcms = complete_tfn_fcms
)

simple_salinization_fcms <- list(
  conventional_fcms = simple_conventional_fcms,
  ivfn_fcms = simple_ivfn_fcms,
  tfn_fcms = simple_tfn_fcms
)

sample_fcms <- list(
  simple_fcms = simple_salinization_fcms,
  large_fcms = salinization_fcms
)

# usethis::use_data(sample_fcms, overwrite = TRUE)
