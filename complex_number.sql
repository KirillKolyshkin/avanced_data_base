CREATE TYPE my_complex AS
(
    valueA NUMERIC,
    valueB NUMERIC
);

CREATE TABLE test_complex
(
    id    INT,
    value my_complex
);

CREATE OR REPLACE FUNCTION complex_addition(first_el my_complex, second_el my_complex) RETURNS my_complex AS
$$
BEGIN
    return (first_el.valuea + second_el.valuea, first_el.valueb + second_el.valueb)::my_complex;
END;
$$
    language 'plpgsql' IMMUTABLE
                       STRICT;

CREATE AGGREGATE complex_addition(my_complex)(
    stype = my_complex,
    sfunc = complex_addition);

CREATE OR REPLACE FUNCTION complex_subtraction(first_el my_complex, second_el my_complex) RETURNS my_complex AS
$$
BEGIN
    return (first_el.valuea - second_el.valuea, first_el.valueb - second_el.valueb)::my_complex;
END;
$$
    language 'plpgsql' IMMUTABLE
                       STRICT;

CREATE AGGREGATE complex_subtraction(my_complex)(
    stype = my_complex,
    sfunc = complex_subtraction,
    initcond = '(0,0)');


CREATE OR REPLACE FUNCTION complex_multiplication(first_el my_complex, second_el my_complex) RETURNS my_complex AS
$$
BEGIN
    return (first_el.valuea * second_el.valuea - first_el.valueb * second_el.valueb,
            first_el.valueb * second_el.valuea + first_el.valuea * second_el.valueb)::my_complex;
END;
$$
    language 'plpgsql' IMMUTABLE
                       STRICT;

CREATE AGGREGATE complex_multiplication(my_complex)(
    stype = my_complex,
    sfunc = complex_multiplication);

CREATE OR REPLACE FUNCTION complex_division(first_el my_complex, second_el my_complex) RETURNS my_complex AS
$$
BEGIN
    return ((first_el.valuea * second_el.valuea + first_el.valueb * second_el.valueb) /
            (second_el.valuea * second_el.valuea + second_el.valueb * second_el.valueb),
            (first_el.valueb * second_el.valuea - first_el.valuea * second_el.valueb) /
            (second_el.valuea * second_el.valuea + second_el.valueb * second_el.valueb))::my_complex;
END;
$$
    language 'plpgsql' IMMUTABLE
                       STRICT;

CREATE AGGREGATE complex_division(my_complex)(
    stype = my_complex,
    sfunc = complex_division);


INSERT INTO test_complex(id, value)
SELECT i, (i, i+1)::my_complex from generate_series(1,1000) As t(i);
