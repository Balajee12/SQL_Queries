with cte1 as (
    select
        *,
        sum(weight) over(order by turn) as rt
        from Queue
)
select
    person_name
from cte1
where rt <= 1000
order by rt desc
limit 1;