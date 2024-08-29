with
    raw_data as (
        select
            pokedex_number,
            name,
            generation,
            generation_desc,
            type1,
            type2,
            experience_growth,
            overall_legendary,
            final_stage,
            avg(hp) as hp,
            avg(attack) as attack,
            avg(defense) as defense,
            avg(special_attack) as special_attack,
            avg(special_defense) as special_defense,
            avg(speed) as speed,
            avg(physical_sweeper) as physical_sweeper,
            avg(special_sweeper) as special_sweeper,
            avg(wall) as wall,
            avg(physical_tank) as physical_tank,
            avg(special_tank) as special_tank,
            avg(male_percentage) as male_percentage,
            avg(female_percentage) as female_percentage,
            avg(height) as height,
            avg(weight) as weight,
            avg(capture_rate) as capture_rate,
            avg(base_happiness) as base_happiness,
            avg(base_egg_steps) as base_egg_steps
        from {{ ref("pokemon") }}
        where mega_evolution = 0 and regional_form = 0
        group by
            pokedex_number,
            name,
            generation,
            generation_desc,
            type1,
            type2,
            experience_growth,
            overall_legendary,
            final_stage
    )
select hash(a.pokedex_number, a.generation, a.type1, a.type2) as unique_id, a.*
from raw_data a
