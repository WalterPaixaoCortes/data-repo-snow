select pokedex_number, ability, ability_gen, ability_category, activation_requirement
from {{ ref("pokemon") }}
