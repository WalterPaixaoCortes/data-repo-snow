select
    cast("Rank" as int) as wp_rank,
    "CCA3" as country_code,
    "Country" as country_name,
    "Capital" as country_capital,
    "Continent" as country_continent,
    cast("Area (km²)" as number) as country_area_km2,
    cast("Density (per km²)" as number) as density_per_km2,
    cast("Growth Rate" as number) as growth_rate,
    cast("World Population Percentage" as number) as population_percentage,
    cast("2022 Population" as number) as "2022",
    cast("2020 Population" as number) as "2020",
    cast("2015 Population" as number) as "2015",
    cast("2010 Population" as number) as "2010",
    cast("2000 Population" as number) as "2000",
    cast("1990 Population" as number) as "1990",
    cast("1980 Population" as number) as "1980",
    cast("1970 Population" as number) as "1970"
from src.world_population_tbl
