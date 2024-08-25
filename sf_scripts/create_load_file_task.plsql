use schema wvcode_db.public;

create
or replace procedure sp_load_file_task() returns integer not null as
declare
  file_name varchar default 'nofile';

table_name varchar;

inferred_schema varchar;

table_found integer default 0;

create_cmd varchar;

copy_cmd varchar;

begin
  -- Get the most recent file name from the stage
select
  metadata$filename into :file_name
from
  @ public.wvcode_stage
order by
  metadata$file_last_modified desc
limit
  1;

if (file_name <> 'nofile') then -- Extract the base file name (without extension) to use as the table name
select
  split_part(:file_name, '.', 1) into :table_name;

-- Check if the table already exists
select
  count(1) into :table_found
from
  information_schema.tables
where
  table_name = :table_name;

if (table_found = 0) then create_cmd := 'CREATE OR REPLACE TABLE src.' || table_name || '_tbl USING TEMPLATE (SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) WITHIN GROUP (ORDER BY ORDER_ID) ' || ' FROM TABLE(INFER_SCHEMA(LOCATION=>''@public.wvcode_stage/' || file_name || ''', FILE_FORMAT=>''wvcode_csv_0'')));';

-- Dynamically construct the CREATE TABLE statement using the inferred schema
execute immediate :create_cmd;

end if;

-- Now run the COPY INTO command to load the data into the newly created (or existing)
-- table
copy_cmd := 'COPY INTO src.' || table_name || '_tbl FROM @public.wvcode_stage/' || file_name || ' FILE_FORMAT = (FORMAT_NAME = ''wvcode_csv'') ON_ERROR = ''CONTINUE'' PURGE = TRUE;';

execute immediate :copy_cmd;

end if;

end;

create
or replace task load_file_task WAREHOUSE = WVCODE_WH SCHEDULE = '1 MINUTE' as call sp_load_file_task();

alter task load_file_task RESUME;