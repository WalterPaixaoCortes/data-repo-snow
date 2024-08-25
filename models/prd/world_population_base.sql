select *
from
    {{ ref("world_population") }} unpivot (
        population for year
        in ("2022", "2020", "2015", "2010", "2000", "1990", "1980", "1970")
    )
