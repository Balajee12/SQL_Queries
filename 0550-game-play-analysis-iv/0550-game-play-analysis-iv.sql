with cte1 as (
    select
        player_id,
        min(event_date) as first_date
    from activity 
    group by player_id
)
select
    round(count(
        case when datediff(a.event_date, f.first_date) = 1 then 1 end
    )/count(distinct f.player_id), 2) as fraction
from cte1 f
left join Activity a
    on f.player_id = a.player_id;
