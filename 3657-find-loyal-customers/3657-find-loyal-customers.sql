with cte1 as (
    select
        customer_id,
        transaction_date,
        transaction_type,
        sum(case when transaction_type = 'purchase' then 1 else 0 end) as cnt,
        min(case when transaction_type in ('purchase' , 'refund') then transaction_date end) as mi_date,
        max(case when transaction_type in ('purchase' , 'refund') then transaction_date end) as ma_date,
        sum(case when transaction_type = 'refund' then 1 else 0 end) *100 / count(*) as refund
    from customer_transactions
    group by customer_id
)
select
    customer_id
from cte1
where cnt >=3 and datediff(ma_date, mi_date) >= 30 and refund < 20
order by customer_id asc;