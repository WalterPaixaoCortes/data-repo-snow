select pokedex_id, trim(value) as ability
from {{ ref("pokemon") }}, lateral split_to_table(abilities, ',')
