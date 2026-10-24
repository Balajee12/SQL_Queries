# Write your MySQL query statement below
with cte1 as (
    select user_id,
    case when action='confirmed' then 1 else 0 end as act 
    from confirmations
    )
select s.user_id,
coalesce(round(sum(act)/count(act),2),0.00) as confirmation_rate 
from signups s 
left join cte1 c 
on s.user_id = c.user_id 
group by user_id
order by confirmation_rate  asc;