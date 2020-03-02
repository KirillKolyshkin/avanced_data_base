CREATE EXTENSION pageinspect;

CREATE OR REPLACE FUNCTION createTable(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %s (id serial, textField varchar)', tableName);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION modifyToastStrategy(tableName varchar, toastType varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('ALTER TABLE %s ALTER COLUMN textField SET STORAGE %s', tableName, toastType);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION random_string(int)
    RETURNS text
AS
$$
SELECT array_to_string(
               ARRAY(
                       SELECT substring(
                                      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                                      FROM (random() * 26)::int FOR 1)
                       FROM generate_series(1, $1)), '')
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insertValues(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'DO
    $do$
        BEGIN
            FOR t IN 1..100
                LOOP
                    INSERT INTO %s (textfield) VALUES (random_string(3500));
                END LOOP;
        END;
    $do$;', tableName);
END;
$$ language plpgsql;

SELECT *
FROM createTable('table1');
SELECT *
FROM createTable('table2');
SELECT *
FROM createTable('table3');
SELECT *
FROM createTable('table4');

SELECT *
FROM modifyToastStrategy('table1', 'PLAIN');
SELECT
FROM modifyToastStrategy('table2', 'EXTENDED');
SELECT *
FROM modifyToastStrategy('table3', 'EXTERNAL');
SELECT *
FROM modifyToastStrategy('table4', 'MAIN');

TRUNCATE table1;
TRUNCATE table2;
TRUNCATE table3;
TRUNCATE table4;

SELECT *
FROM insertValues('table1');
SELECT *
FROM insertValues('table2');
SELECT *
FROM insertValues('table3');
SELECT *
FROM insertValues('table4');

SELECT table_name
     , pg_size_pretty(total_bytes) AS total
     , pg_size_pretty(toast_bytes) AS toast
     , pg_size_pretty(table_bytes) AS "table"
FROM (
         SELECT table_name, total_bytes, toast_bytes, total_bytes - COALESCE(toast_bytes, 0) AS table_bytes
         FROM (
                  SELECT c.oid
                       , relname                               AS TABLE_NAME
                       , pg_total_relation_size(c.oid)         AS total_bytes
                       , pg_total_relation_size(reltoastrelid) AS toast_bytes
                  FROM pg_class c
                           LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
                  WHERE relkind = 'r'
              ) a
         where a.TABLE_NAME = 'table1'
            or a.TABLE_NAME = 'table2'
            or a.TABLE_NAME = 'table3'
            or a.TABLE_NAME = 'table4'
     ) a;

EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM get_raw_page('table1', 0);
SELECT ctid, *
FROM pg_toast.pg_toast_16474;
SELECT *
FROM page_header(get_raw_page('pg_toast.pg_toast_16474', 0));-- выдает ошибку тк таблица пустая

EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM get_raw_page('table2', 0);
SELECT ctid, *
FROM pg_toast.pg_toast_16435;
SELECT *
FROM page_header(get_raw_page('pg_toast.pg_toast_16435', 0));

EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM get_raw_page('table3', 0);
SELECT ctid, *
FROM pg_toast.pg_toast_16455;
SELECT *
FROM page_header(get_raw_page('pg_toast.pg_toast_16455', 0));


EXPLAIN (ANALYSE, TIMING)
SELECT *
FROM get_raw_page('table4', 0);
SELECT ctid, *
FROM pg_toast.pg_toast_16444;
SELECT *
FROM page_header(get_raw_page('pg_toast.pg_toast_16444', 0));-- выдает ошибку тк таблица пустая


SELECT class.oid                       as "OID",
       relname                         as "Relation Name",
       usr.rolname                     as "object owner",
       relpages                        as "Amount pages",
       reltuples                       as "Amount Tuples",
       reltoastrelid                   as "Toast table",
       pg_relation_filepath(class.oid) as "File Path"
FROM pg_class class
         INNER JOIN pg_authid usr on usr.oid = class.relowner
WHERE relname = 'table4';

SELECT count(*) FROM table1;
SELECT count(*) FROM table2;
SELECT count(*) FROM table3;
SELECT count(*) FROM table4;

SELECT count(*) from get_raw_page('pg_toast.pg_toast_16455', 0);

