CREATE table b_tree_table
(
    A INT,
    B INT,
    C INT
);

INSERT INTO b_tree_table(A, B, C)
SELECT random_between(1, 100000), random_between(1, 100000), random_between(1, 100000)
from generate_series(1, 1000);

CREATE INDEX CONCURRENTLY a_index ON b_tree_table (A);
CREATE INDEX CONCURRENTLY b_index ON b_tree_table (B);
CREATE INDEX CONCURRENTLY c_index ON b_tree_table (C);
CREATE INDEX CONCURRENTLY a_b_index ON b_tree_table (A, B);
CREATE INDEX CONCURRENTLY a_c_index ON b_tree_table (A, C);
CREATE INDEX CONCURRENTLY b_a_index ON b_tree_table (B, A);
CREATE INDEX CONCURRENTLY c_a_index ON b_tree_table (C, A);
CREATE INDEX CONCURRENTLY b_c_index ON b_tree_table (B, C);
CREATE INDEX CONCURRENTLY c_b_index ON b_tree_table (C, B);
CREATE INDEX CONCURRENTLY a_b_c_index ON b_tree_table (A, B, C);
CREATE INDEX CONCURRENTLY a_c_b_index ON b_tree_table (A, C, B);
CREATE INDEX CONCURRENTLY b_a_c_index ON b_tree_table (B, A, C);
CREATE INDEX CONCURRENTLY b_c_a_index ON b_tree_table (B, C, A);
CREATE INDEX CONCURRENTLY c_b_a_index ON b_tree_table (C, B, A);
CREATE INDEX CONCURRENTLY c_a_b_index ON b_tree_table (C, A, B);
