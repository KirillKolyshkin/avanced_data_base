
create table table_13
(
    type_name VARCHAR,
    value     INT
);

INSERT INTO table_13 (type_name, value)
SELECT 'test', i FROM generate_series(1, 1000) as t(i);

create or replace VIEW table_13_view AS
SELECT type_name, sum(value)
FROM table_13
GROUP BY type_name;

CREATE OR REPLACE FUNCTION insert_trigger_fun() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO table_13 VALUES (NEW.type_name, NEW.sum - (Select sum(value) from table_13 where type_name = NEW.type_name));
    RETURN NEW;
END;
$$;

CREATE TRIGGER table_13_trigger
    INSTEAD OF INSERT
    ON table_13_view
    FOR EACH ROW
EXECUTE FUNCTION insert_trigger_fun();
