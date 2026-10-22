select 
    customer_id,
    count(v.visit_id) as count_no_trans
from Visits v
where v.visit_id not in (
    select visit_id 
    from Transactions
)
group by customer_id
order by count_no_trans desc;