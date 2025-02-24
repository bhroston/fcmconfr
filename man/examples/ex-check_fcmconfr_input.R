
# Check input is a square adjacency matrix
check_fcmconfr_input(sample_fcms$simple_fcms$conventional_fcms[[1]],
                     check = 'square_adj_matrix',
                     var_name = 'adj_matrix')

# Check input matches an item in a list (of choices)
check_fcmconfr_input("sigmoid",
                     check = 'choice_selection',
                     var_name = 'squashing',
                     choice_selection_choices = c("sigmoid", "squashing"))

# Check input is a numeric vector (length > 1)
check_fcmconfr_input(c(1, 1, 1),
                     check = 'numeric_vector',
                     var_name = 'initial_state_vector')

# Check input is a positive number
check_fcmconfr_input(1.1,
                     check = 'positive_number',
                     var_name = 'initial_state_vector')

# Check input is a positive integer
check_fcmconfr_input(1,
                     check = 'positive_number',
                     var_name = 'initial_state_vector')


