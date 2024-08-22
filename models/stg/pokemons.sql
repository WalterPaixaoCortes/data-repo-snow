select "Number" as number, "Name" as name, "Type 1" as type1, "Type 2" as type2
from {{ source("src", "pokemons_tbl") }}
where "Number" is not null
