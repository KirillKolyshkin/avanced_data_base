CREATE EXTENSION pageinspect;

CREATE OR REPLACE FUNCTION createTableTask2(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %s (id serial, textField varchar(100), datеColumn date)', tableName);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION changeFillFactor(tableName varchar, fillFactor int) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('ALTER TABLE %s SET (FILLFACTOR = %s)', tableName, fillFactor);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION random_string(int)
    RETURNS text
AS
$$
SELECT array_to_string(
               ARRAY(
                       SELECT substring(
                                      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', trunc(random() * 26)::integer + 1, 1)
                       FROM generate_series(1, $1)), '')
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insertValuesTask2(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'DO
    $do$
        BEGIN
            FOR t IN 1..10000
                LOOP
                    INSERT INTO %s (textfield) VALUES (random_string(50));
                END LOOP;
        END;
    $do$;', tableName);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION updateTable(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('UPDATE %s SET textfield = random_string(100)', tableName);
END;
$$ language plpgsql;

SELECT *
FROM createTableTask2('table1task2');
SELECT *
FROM createTableTask2('table2task2');
SELECT *
FROM createTableTask2('table3task2');
SELECT *
FROM createTableTask2('table4task2');

SELECT *
FROM changeFillFactor('table1task2', 50);
SELECT *
FROM changeFillFactor('table2task2', 75);
SELECT *
FROM changeFillFactor('table3task2', 90);
SELECT *
FROM changeFillFactor('table4task2', 100);

TRUNCATE table1task2;
TRUNCATE table2task2;
TRUNCATE table3task2;
TRUNCATE table4task2;

SELECT *
FROM insertValuesTask2('table1task2');
SELECT *
FROM insertValuesTask2('table2task2');
SELECT *
FROM insertValuesTask2('table3task2');
SELECT *
FROM insertValuesTask2('table4task2');


EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM updateTable('table1task2');

EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM updateTable('table2task2');

EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM updateTable('table3task2');

EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM updateTable('table4task2');


EXPLAIN (ANALYSE, TIMING)
SELECT textfield
FROM table1task2;

EXPLAIN (ANALYSE, TIMING)
SELECT textfield
FROM table2task2;

EXPLAIN (ANALYSE, TIMING)
SELECT textfield
FROM table3task2;

EXPLAIN (ANALYSE, TIMING)
SELECT textfield
FROM table4task2;

SELECT table_name
     , pg_size_pretty(total_bytes) AS total
FROM (
         SELECT table_name, total_bytes
         FROM (
                  SELECT c.oid
                       , relname                       AS TABLE_NAME
                       , pg_total_relation_size(c.oid) AS total_bytes
                  FROM pg_class c
                           LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
                  WHERE relkind = 'r'
              ) a
         where a.TABLE_NAME = 'table1task2'
            or a.TABLE_NAME = 'table2task2'
            or a.TABLE_NAME = 'table3task2'
            or a.TABLE_NAME = 'table4task2'
     ) a;