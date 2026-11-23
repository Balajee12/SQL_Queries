with cte1 as (
    select
        d.driver_id,
        d.driver_name,
        avg (case when month(trip_date) between 1 and 6 then distance_km / fuel_consumed end) as first_half_avg,
        avg (case when month(trip_date) between 7 and 12 then distance_km / fuel_consumed end) as second_half_avg
    from drivers d
    join trips t 
        on d.driver_id = t.driver_id
    group by driver_id
    HAVING
        SUM(CASE WHEN MONTH(trip_date) BETWEEN 1 AND 6 THEN 1 ELSE 0 END) > 0
        AND
        SUM(CASE WHEN MONTH(trip_date) BETWEEN 7 AND 12 THEN 1 ELSE 0 END) > 0
)
select 
    driver_id,
    driver_name,
    round(first_half_avg,2) as first_half_avg,
    round(second_half_avg,2) as second_half_avg,
    round(second_half_avg - first_half_avg,2) as efficiency_improvement
from cte1
where second_half_avg > first_half_avg
order by efficiency_improvement desc, driver_name asc;