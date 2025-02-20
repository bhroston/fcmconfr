
# a quick test:
X = matrix(1:9, nrow = 3)
Y = matrix(1:12, nrow = 4)
Z = data.frame(matrix(1:9, nrow = 3))
check_square_adj_matrix(X)
check_square_adj_matrix(Y)
check_square_adj_matrix(Z)
