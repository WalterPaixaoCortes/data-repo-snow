CREATE
OR REPLACE TABLE POKEMONS_TBL USING TEMPLATE (
  SELECT
    ARRAY_AGG(OBJECT_CONSTRUCT(*)) WITHIN GROUP (
      ORDER BY
        ORDER_ID
    )
  FROM
    TABLE(
      INFER_SCHEMA(
        LOCATION = > '@public.wvcode_stage/pokemons.csv',
        FILE_FORMAT = > 'wvcode_csv_0'
      )
    )
);

create
or replace pipe public.pipe_pokemons_tbl auto_ingest = true integration = wvcode_not as copy into wvcode_db.src.pokemons_tbl
from
  '@wvcode_db.public.wvcode_stage/pokemons.csv' on_error = CONTINUE;