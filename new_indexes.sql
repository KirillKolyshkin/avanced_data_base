

create function random_string_new(integer) returns text
    language sql
as
$$
SELECT array_to_string(
               ARRAY(
                       SELECT substring(
                                      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ ', trunc(random() * 27)::integer + 1, 1)
                       FROM generate_series(1, $1)), '')
$$;

alter function random_string_new(integer) owner to postgres;
                   
DROP table table_with_btree;

CREATE TABLE table_with_gin(
    id INT, content varchar
);

CREATE TABLE table_with_btree(
    id INT, content varchar
);

CREATE TABLE table_with_gist(
    id INT, content varchar
);

INSERT INTO table_with_btree (id, content)
SELECT  i, random_string_new(100) FROM generate_series(1, 1000000) as t(i);

INSERT INTO table_with_gin (id, content)
SELECT  i, random_string_new(100) FROM generate_series(1, 1000000) as t(i);

INSERT INTO table_with_gist (id, content)
SELECT  i, random_string_new(100) FROM generate_series(1, 1000000) as t(i);

CREATE EXTENSION pg_trgm;
CREATE INDEX CONCURRENTLY idx_gin_table ON table_with_gin USING gin(content gin_trgm_ops);
CREATE INDEX CONCURRENTLY idx_gist_table ON table_with_gist USING gist(content gist_trgm_ops);
CREATE INDEX CONCURRENTLY idx_btree_table ON table_with_btree (content);
