
CREATE TABLE table_join_1(
    id INT, content varchar
);
CREATE TABLE table_join_2(
    id INT, content_add varchar
);
CREATE TABLE table_join_3(
    id INT, content_add_3 varchar
);
CREATE TABLE table_join_4(
    id INT, content_add_4 varchar
);
CREATE TABLE table_join_5(
    id INT, content_add_5 varchar
);
CREATE TABLE table_join_6(
    id INT, content_add_6 varchar
);
CREATE TABLE table_join_7(
    id INT, content_add_7 varchar
);
CREATE TABLE table_join_8(
    id INT, content_add_8 varchar
);

INSERT INTO table_join_1 (id, content)
SELECT  i, i::varchar FROM generate_series(1, 1000000) as t(i);

INSERT INTO table_join_2 (id, content_add)
SELECT  i, i::varchar FROM generate_series(500000, 1000000) as t(i);

INSERT INTO table_join_3 (id, content_add_3)
SELECT  i, i::varchar FROM generate_series(200000, 1200000) as t(i);

INSERT INTO table_join_4 (id, content_add_4)
SELECT  i, i::varchar FROM generate_series(100000, 1300000) as t(i);

INSERT INTO table_join_5 (id, content_add_5)
SELECT  i, i::varchar FROM generate_series(500000, 1500000) as t(i);

INSERT INTO table_join_6 (id, content_add_6)
SELECT  i, i::varchar FROM generate_series(200000, 800000) as t(i);

INSERT INTO table_join_7 (id, content_add_7)
SELECT  i, i::varchar FROM generate_series(600000, 1000000) as t(i);

INSERT INTO table_join_8 (id, content_add_8)
SELECT  i, i::varchar FROM generate_series(700000, 750000) as t(i);
