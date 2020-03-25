create table users
(
    id   integer,
    name varchar
);
create index idx_users on users (id);

CREATE OR REPLACE FUNCTION createTable(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %s () INHERITS(users)', tableName);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION addRule(tableName varchar, startId integer, finishId integer) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'CREATE OR REPLACE RULE redirect_insert_to_%s AS ON INSERT TO users WHERE NEW.id BETWEEN %s AND %s DO INSTEAD INSERT INTO %s VALUES (NEW.id, NEW.name)',
            tableName, startId, finishId, tableName);
END ;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION addRuleForUpdate(tableName varchar, startId integer, finishId integer) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'CREATE OR REPLACE RULE redirect_update_to_%s AS ON UPDATE TO users WHERE NEW.id BETWEEN %s AND %s DO INSTEAD UPDATE %s SET name = NEW.name WHERE id = NEW.id',
            tableName, startId, finishId, tableName);
END ;
$$ language plpgsql;

SELECT *
FROM
    createTable('users_1');
SELECT *
FROM
    createTable('users_2');
SELECT *
FROM
    createTable('users_3');
SELECT *
FROM
    createTable('users_4');
SELECT *
FROM
    createTable('users_5');
SELECT *
FROM
    createTable('users_6');
SELECT *
FROM
    createTable('users_7');
SELECT *
FROM
    createTable('users_8');
SELECT *
FROM
    createTable('users_9');
SELECT *
FROM
    createTable('users_10');

SELECT *
FROM
    addRule('users_1', 0, 99999);
SELECT *
FROM
    addRule('users_2', 100000, 199999);
SELECT *
FROM
    addRule('users_3', 200000, 299999);
SELECT *
FROM
    addRule('users_4', 300000, 399999);
SELECT *
FROM
    addRule('users_5', 400000, 499999);
SELECT *
FROM
    addRule('users_6', 500000, 599999);
SELECT *
FROM
    addRule('users_7', 600000, 699999);
SELECT *
FROM
    addRule('users_8', 700000, 799999);
SELECT *
FROM
    addRule('users_9', 800000, 899999);
SELECT *
FROM
    addRule('users_10', 900000, 999999);


SELECT *
FROM
    addRuleForUpdate('users_1', 0, 99999);
SELECT *
FROM
    addRuleForUpdate('users_2', 100000, 199999);
SELECT *
FROM
    addRuleForUpdate('users_3', 200000, 299999);
SELECT *
FROM
    addRuleForUpdate('users_4', 300000, 399999);
SELECT *
FROM
    addRuleForUpdate('users_5', 400000, 499999);
SELECT *
FROM
    addRuleForUpdate('users_6', 500000, 599999);
SELECT *
FROM
    addRuleForUpdate('users_7', 600000, 699999);
SELECT *
FROM
    addRuleForUpdate('users_8', 700000, 799999);
SELECT *
FROM
    addRuleForUpdate('users_9', 800000, 899999);
SELECT *
FROM
    addRuleForUpdate('users_10', 900000, 999999);
