CREATE OPERATOR + (
   leftarg = my_complex,
   rightarg = my_complex,
   procedure = complex_addition,
   commutator = +
);

CREATE OPERATOR - (
   leftarg = my_complex,
   rightarg = my_complex,
   procedure = complex_subtraction,
   commutator = -
);

CREATE OPERATOR * (
   leftarg = my_complex,
   rightarg = my_complex,
   procedure = complex_multiplication,
   commutator = *
);

CREATE OPERATOR / (
   leftarg = my_complex,
   rightarg = my_complex,
   procedure = complex_division,
   commutator = /
);
