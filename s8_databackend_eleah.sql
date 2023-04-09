SELECT c.relname AS table_name, 
       n.nspname AS schema_name,
       0 AS row_count
FROM pg_class c
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r' 
  AND c.relname NOT LIKE 'pg_%' 
  AND c.relname NOT LIKE 'sql_%'
  AND c.reltuples = 0
ORDER BY n.nspname, c.relname;

CREATE OR REPLACE FUNCTION generate_create_table_dl(tablename text)
RETURNS text AS $$
DECLARE
    column_info record;
    sql text := 'CREATE TABLE '  tablename  ' (';
BEGIN
    FOR column_info IN (
        SELECT column_name, data_type  COALESCE('('  character_maximum_length  ')', ''), is_nullable
        FROM information_schema.columns
        WHERE table_name = tablename
        ORDER BY ordinal_position
    ) LOOP
        sql := sql  column_info.column_name  ' '  column_info.data_type  
               CASE WHEN column_info.is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END  ', ';
    END LOOP;
    sql := left(sql, length(sql) - 2) || ');';
    RETURN sql;
END;
$$ LANGUAGE plpgsql;

SELECT generate_create_table_dl('people');