DO language 'plpgsql'
$$
    DECLARE
        var_sql text := 'CREATE TABLE first_101_table('
                            || string_agg('bigint_' || i::text || ' BIGINT', ',') ||
                        ', char_1 varchar(255));' FROM generate_series(1,100) As i;
    BEGIN
        EXECUTE var_sql;
    END;
$$;

DO language 'plpgsql'
$$
    DECLARE
        var_sql text := 'CREATE TABLE second_101_table( char_1 varchar(255),'
                            || string_agg('bigint_' || i::text || ' BIGINT', ',') ||
                        ');' FROM generate_series(1,100) As i;
    BEGIN
        EXECUTE var_sql;
    END;
$$;

DO language 'plpgsql'
$$
    DECLARE
        var_sql text := 'INSERT INTO first_101_table VALUES ('
                            || string_agg(i::text, ',') || ', ''some text'');' FROM generate_series(1,100) As i;
    BEGIN
        FOR i IN 1..1000000
            LOOP
                EXECUTE var_sql;
            END LOOP;
    END ;
$$;


DO language 'plpgsql'
$$
    DECLARE
        var_sql text := 'INSERT INTO second_101_table VALUES (''some text'','
                            || string_agg(i::text, ',') || ');' FROM generate_series(1,100) As i;
    BEGIN
        FOR i IN 1..1000000
            LOOP
                EXECUTE var_sql;
            END LOOP;
    END ;
$$;
