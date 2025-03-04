
# Check input is an acceptable list of adjacency matrices
check_fcmconfr_input(sample_fcms$simple_fcms$conventional_fcms,
                     check = "adj_matrix_list")

# Check input is a square adjacency matrix
check_fcmconfr_input(sample_fcms$simple_fcms$conventional_fcms[[1]],
                     check = 'square_adj_matrix',
                     var_name = 'adj_matrix')

# Check input matches an item in a list (of choices)
check_fcmconfr_input("sigmoid",
                     check = 'choice_selection',
                     var_name = 'squashing',
                     choice_selection_opts = c("sigmoid", "squashing"))

# Check input is a numeric vector
check_fcmconfr_input(c(1, 1, 1),
                     check = 'numeric_vector',
                     var_name = 'initial_state_vector')

# Check input is a ivfn vector
check_fcmconfr_input(c(ivfn(1, 1), ivfn(1, 1), ivfn(1, 1)),
                     check = 'ivfn_vector',
                     var_name = 'state_vector')

# Check input is a ivfn vector
check_fcmconfr_input(c(tfn(1, 1, 1), tfn(1, 1, 1), tfn(1, 1, 1)),
                     check = 'tfn_vector',
                     var_name = 'state_vector')

# Check input is a positive number
check_fcmconfr_input(1.1,
                     check = 'positive_number',
                     var_name = 'initial_state_vector')

# Check input is a positive integer
check_fcmconfr_input(1,
                     check = 'positive_number',
                     var_name = 'initial_state_vector')


