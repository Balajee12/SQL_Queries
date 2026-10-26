with first_login as(
    select
        player_id,
        min(event_date) as first_date
    from Activity
    group by player_id
)
select
    round(count(
        case when datediff(a.event_date, f.first_date) = 1 then 1 end ) / count(distinct f.player_id), 2) as fraction
from first_login f
left join Activity a
    on f.player_id = a.player_id;