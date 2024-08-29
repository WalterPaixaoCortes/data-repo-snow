select * from {{ ref("pokemon_alternate_forms") }} where mega_evolution = 1
