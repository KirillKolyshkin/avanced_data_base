
create table users
(
    id   integer,
    name varchar
);
create index idx_users on users (id);

CREATE OR REPLACE FUNCTION createTable(tableName varchar) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %s () INHERITS(users);', tableName);
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION addRule(tableName varchar, startId integer, finishId integer) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'CREATE OR REPLACE RULE redirect_insert_to_%s AS ON INSERT TO users WHERE NEW.id BETWEEN %s AND %s DO INSTEAD INSERT INTO %s VALUES (NEW.id, NEW.name);',
            tableName, startId, finishId, tableName);
END ;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION addPartionCheck(tableName varchar, startId integer, finishId integer) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'ALTER TABLE %s ADD CONSTRAINT partition_check_%s CHECK (id >= %s and id <= %s);',
            tableName, tableName, startId, finishId);
END ;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION addRuleForUpdate(tableName varchar, startId integer, finishId integer,
                                            addingCost integer) RETURNS VOID AS
$$
BEGIN
    EXECUTE format(
            'CREATE OR REPLACE RULE redirect_update_to_%s AS ON UPDATE TO users WHERE NEW.id BETWEEN %s AND %s DO INSTEAD(
            INSERT INTO users VALUES (NEW.id + %s, NEW.name); DELETE FROM %s WHERE id = NEW.id)',
            tableName, startId, finishId, addingCost, tableName);
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
    addPartionCheck('users_1', 0, 99999);
SELECT *
FROM
    addPartionCheck('users_2', 100000, 199999);
SELECT *
FROM
    addPartionCheck('users_3', 200000, 299999);
SELECT *
FROM
    addPartionCheck('users_4', 300000, 399999);
SELECT *
FROM
    addPartionCheck('users_5', 400000, 499999);
SELECT *
FROM
    addPartionCheck('users_6', 500000, 599999);
SELECT *
FROM
    addPartionCheck('users_7', 600000, 699999);
SELECT *
FROM
    addPartionCheck('users_8', 700000, 799999);
SELECT *
FROM
    addPartionCheck('users_9', 800000, 899999);
SELECT *
FROM
    addPartionCheck('users_10', 900000, 999999);


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
    addRuleForUpdate('users_1', 0, 99999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_2', 100000, 199999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_3', 200000, 299999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_4', 300000, 399999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_5', 400000, 499999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_6', 500000, 599999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_7', 600000, 699999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_8', 700000, 799999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_9', 800000, 899999, 100000);
SELECT *
FROM
    addRuleForUpdate('users_10', 900000, 999999, -900000);

Drop function insert();
CREATE FUNCTION insert() RETURNS void AS
$$
DECLARE
    t int = 0;
BEGIN
    FOR i IN 0..999999
        LOOP
            t = random() * 999999;
            INSERT INTO users (id, name) VALUES (t, 'initname');
        END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT insert();
